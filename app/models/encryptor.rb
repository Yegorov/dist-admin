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

require 'digest'

class Encryptor < ApplicationRecord
  CIPHERS = [
    'aes-256-cbc', 'camellia-256-cbc', 'aes-256-ecb'
  ]

  belongs_to :document
  attr_accessor :pass_phrase

  validates :pass_phrase, :cipher, presence: true
  validates :pass_phrase, length: { in: 7..50 }
  validates :cipher, inclusion: { in: CIPHERS }

  before_create do
    self.pass_phrase_salt = SecureRandom.urlsafe_base64(n=20)
    self.pass_phrase_hash = get_pass_phrase_hash(pass_phrase)
  end

  def verify_pass_phrase(pass_phrase)
    pass_phrase_hash = get_pass_phrase_hash(pass_phrase)
    self.pass_phrase_hash == pass_phrase_hash
  end

  def get_pass_phrase_hash(pass_phrase)
    Digest::SHA2.new(256)
                .hexdigest(
                  pass_phrase_salt +
                  pass_phrase +
                  pass_phrase_salt)
  end
end
