# == Schema Information
#
# Table name: documents
#
#  id         :integer          not null, primary key
#  iid        :integer          not null
#  parent_iid :integer
#  owner_id   :integer
#  creator_id :integer
#  type       :string           not null
#  name       :string           not null
#  real_path  :string           not null
#  size       :integer          default(0)
#  prepared   :boolean          default(FALSE)
#  deleted    :boolean          default(FALSE)
#  hash_sum   :string           default("")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_documents_on_creator_id  (creator_id)
#  index_documents_on_owner_id    (owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (owner_id => users.id)
#

class Document < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :creator, class_name: "User"
  has_many :logs, class_name: "DocumentActionLog", dependent: :delete_all
  has_many :permissions, class_name: "DocumentPermission", dependent: :delete_all
  has_one :encryptor, dependent: :delete
  #accepts_nested_attributes_for :encryptor, :allow_destroy => true

  scope :roots, ->() { where(parent_iid: nil) }
  scope :in_folder, ->(document) { document.nil? ? roots : where(parent_iid: document.iid) }
  scope :available, ->{ where(deleted: false, prepared: true) }
  scope :owned, ->(user){ where(owner: user) }

  validates :name, presence: true
  validate do |document|
    parent_folder = Document.owned(document.owner)
                            .find_by(iid: document.parent_iid) # use parent method
    exist = Document.owned(document.owner)
                    .where(deleted: false)
                    .in_folder(parent_folder)
                    .where.not(iid: document.iid)
                    .exists?(name: document.name)
    if exist
      errors.add(:name, 'must be unique in folder')
    end
  end

  def parent
    Document.owned(self.owner)
            .find_by(iid: self.parent_iid)
  end

  def folder?
    self.type == FileEntity::Folder.to_s
  end

  def file?
    self.type == FileEntity::File.to_s
  end
  def type_s
    if file?
      "File"
    elsif folder?
      "Folder"
    else
      ""
    end
  end
  def prepared!
    # need call when real document ready
    self.update_column(:prepared, true)
  end
  def encrypted?
    if file?
      encryptor.present?
    else
      false
    end
  end

  def encryptor_id
    self.encryptor.try :id
  end

  protected
  # chown_document(new_owner) change owner
  # move_document(to: folder)
  # rename_document(new_name)
  def self.mk_document(name:, real_path:, user:, parent:nil)
    if name.blank?
      raise "'name' required parameter"
    end
    if real_path.blank?
      raise "'real_path' required parameter"
    end
    if user.blank?
      raise "'user' required parameter"
    end

    parent_iid = nil
    if parent.present? and parent.folder?
      parent_iid = parent.try(:iid)
    end

    user.with_lock do
      user.increment(:document_sequence)
      user.save
      self.create(name: name, 
                  real_path: real_path,
                  iid: user.document_sequence,
                  owner: user,
                  creator: user,
                  parent_iid: parent_iid)
    end
  end
end
