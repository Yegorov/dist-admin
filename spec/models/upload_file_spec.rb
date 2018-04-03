# == Schema Information
#
# Table name: upload_files
#
#  id           :integer          not null, primary key
#  file_name    :string           default("file"), not null
#  size         :integer          default(0), not null
#  current_size :integer          default(0), not null
#  path         :string           not null
#  user_id      :integer
#  unique_id    :string           not null
#  to           :string           default("root"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_upload_files_on_unique_id  (unique_id) UNIQUE
#  index_upload_files_on_user_id    (user_id)
#

require 'rails_helper'

RSpec.describe UploadFile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
