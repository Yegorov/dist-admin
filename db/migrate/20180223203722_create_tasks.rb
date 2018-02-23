class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string :name, null: false, default: ""
      t.integer :state, null: false
      t.references :creator
      t.datetime :started_at
      t.datetime :stopped_at
      t.datetime :finished_at

      t.timestamps
    end

    add_foreign_key :tasks, :users, column: :creator_id
  end
end
