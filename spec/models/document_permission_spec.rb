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
#  index_document_permissions_on_document_id              (document_id)
#  index_document_permissions_on_user_id                  (user_id)
#  index_document_permissions_on_user_id_and_document_id  (user_id,document_id) UNIQUE
#

require 'rails_helper'

RSpec.describe DocumentPermission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
