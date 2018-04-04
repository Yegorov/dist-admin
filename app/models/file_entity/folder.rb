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

module FileEntity
  class Folder < Document
    # Directory

    def self.mk_dir(**kwargs) #(name:, real_path:, user:, parent: nil)
      self.mk_document(kwargs)
    end
  end
end
