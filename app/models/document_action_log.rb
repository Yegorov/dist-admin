# == Schema Information
#
# Table name: document_action_logs
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  document_id :integer
#  action      :integer
#  message     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_document_action_logs_on_document_id  (document_id)
#  index_document_action_logs_on_user_id      (user_id)
#

class DocumentActionLog < ApplicationRecord
  include Actionable

  belongs_to :user
  belongs_to :document

  scope :user, ->(u) { where(user: u) }
  scope :document, ->(d) { where(document: d) }

  paginates_per 5
end
