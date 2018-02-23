class CreateDocumentPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :document_permissions do |t|
      t.references :user
      t.references :document, foreign_key: true
      t.integer :action, null: false

      t.timestamps
    end

    add_foreign_key :document_permissions, :users, column: :user_id
    add_foreign_key :documents, :users, column: :document_id

    add_index :document_permissions, [:user_id, :document_id], unique: true
  end
end
