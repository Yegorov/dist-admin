class CreateDocumentActionLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :document_action_logs do |t|
      t.references :user
      t.references :document
      t.integer :action
      t.string :message

      t.timestamps
    end
  end
end
