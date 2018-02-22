class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :role, null: false, default: 2
      t.boolean :banned, null: false, default: false
      t.integer :document_sequence, null: false, default: 0

      t.timestamps
    end
  end
end
