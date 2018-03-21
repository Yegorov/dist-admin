class CreateEncryptors < ActiveRecord::Migration[5.1]
  def change
    create_table :encryptors do |t|
      t.references :document, foreign_key: true
      t.string :cipher
      t.string :pass_phrase_hash
      t.string :pass_phrase_salt

      t.timestamps
    end
  end
end
