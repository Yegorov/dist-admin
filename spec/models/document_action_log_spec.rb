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

require 'rails_helper'

RSpec.describe DocumentActionLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
