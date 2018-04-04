class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false, default: ""
      t.integer :state, null: false, default: 0
      t.boolean :prepared, null: false, default: true
      t.references :owner
      t.references :script
      t.datetime :started_at
      t.datetime :stopped_at
      t.datetime :finished_at

      t.timestamps
    end

    add_foreign_key :tasks, :users, column: :owner_id
  end
end
