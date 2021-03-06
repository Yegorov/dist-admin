class CreateScripts < ActiveRecord::Migration[5.1]
  def change
    create_table :scripts do |t|
      t.string :name, null: false
      t.references :owner
      t.text :description, null: false, default: ""
      t.text :mapper, null: false, default: ""
      t.text :reducer, null: false, default: ""
      t.text :input, null: false, default: ""
      t.text :output, null: false, default: ""
      t.integer :language, null: false, default: 1

      t.timestamps
    end

    add_foreign_key :scripts, :users, column: :owner_id

    add_foreign_key :tasks, :scripts, column: :script_id, on_delete: :nullify
  end
end
