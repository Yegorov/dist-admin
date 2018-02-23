class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.integer :iid,  null: false
      t.integer :parent_iid, default: nil
      t.references :owner
      t.references :creator
      t.string :type, null: false
      t.string :name, null: false
      t.string :real_path, null: false
      t.integer :size, nil: false, default: 0
      t.boolean :prepared, nil: false, default: false
      t.boolean :deleted, nil: false, default: false
      t.string :hash_sum, nil: false, default: ""

      t.timestamps
    end
    add_foreign_key :documents, :users, column: :owner_id
    add_foreign_key :documents, :users, column: :creator_id
  end
end
