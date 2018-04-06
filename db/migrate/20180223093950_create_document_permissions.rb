class CreateDocumentPermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :document_permissions do |t|
      t.references :user
      t.references :document
      t.integer :action, null: false

      t.timestamps
    end

    add_foreign_key :document_permissions, :users, column: :user_id
    add_foreign_key :document_permissions, :documents, column: :document_id

    add_index :document_permissions, [:user_id, :document_id, :action],
              unique: true, name: "idx_user_document_action"
  end
end
