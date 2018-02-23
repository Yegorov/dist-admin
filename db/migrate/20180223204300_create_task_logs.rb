class CreateTaskLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :task_logs do |t|
      t.integer :state
      t.references :task
      t.string :message

      t.timestamps
    end
    add_foreign_key :task_logs, :tasks, column: :task_id
  end
end
