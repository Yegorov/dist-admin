class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :login, null: false

      t.integer :role, null: false, default: 2
      t.boolean :banned, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.integer :document_sequence, null: false, default: 0

      t.timestamps
    end
    add_index :users, :login, unique: true
  end
end
