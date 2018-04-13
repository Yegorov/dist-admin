class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.text :message, default: ""
      t.string :status, null: false, default: "info"
      t.string :subject, null: false, default: "unknown"

      t.timestamps
    end
  end
end
