# == Schema Information
#
# Table name: document_permissions
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  document_id :integer
#  action      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  idx_user_document_action                   (user_id,document_id,action) UNIQUE
#  index_document_permissions_on_document_id  (document_id)
#  index_document_permissions_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (document_id => users.id)
#  fk_rails_...  (user_id => users.id)
#

class DocumentPermission < ApplicationRecord
  include Actionable

  belongs_to :user
  belongs_to :document

  scope :user, ->(u) { where(user: u) }
  scope :document, ->(d) { where(document: d) }

  paginates_per 5


  def last_updated_at
    if attributes['last_updated_at']
      ActiveSupport::TimeZone[Time.zone.name].parse(attributes['last_updated_at'].to_s)
    else
      updated_at
    end
  end
end
