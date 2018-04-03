class CreateUploadFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :upload_files do |t|
      t.string :file_name, null: false, default: "file"
      t.integer :size, null: false, default: 0
      t.integer :current_size, null: false, default: 0
      t.string :path, null: false
      t.references :user
      t.string :unique_id, null: false
      t.string :to, null: false, default: "root"

      t.timestamps
    end
    add_foreign_key :upload_files, :users, column: :user_id
    add_index :upload_files, :unique_id, unique: true
  end
end
