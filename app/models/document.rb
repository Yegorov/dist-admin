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

class Document < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :creator, class_name: "User"

  def folder?
    self.type == FileEntity::Folder.to_s
  end

  def file?
    self.type == FileEntity::File.to_s
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
    if parent.present?
      if parent.type == "Folder"
        parent_iid = parent.try(:iid)
      end
    end

    user.with_lock do
      user.increment(:document_sequence)
      self.create(name: name, 
                  real_path: real_path,
                  iid: user.document_sequence,
                  owner: user,
                  creator: user,
                  parent_iid: parent_iid)
      user.save
    end
  end
end
