class CreateEncryptors < ActiveRecord::Migration[5.1]
  def change
    create_table :encryptors do |t|
      t.references :document
      t.string :cipher
      t.string :pass_phrase_hash
      t.string :pass_phrase_salt

      t.timestamps
    end
    add_foreign_key :encryptors, :documents, column: :document_id
  end
end
