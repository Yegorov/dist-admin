# == Schema Information
#
# Table name: encryptors
#
#  id               :integer          not null, primary key
#  document_id      :integer
#  cipher           :string
#  pass_phrase_hash :string
#  pass_phrase_salt :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_encryptors_on_document_id  (document_id)
#

require 'rails_helper'

RSpec.describe Encryptor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
