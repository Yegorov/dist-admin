# == Schema Information
#
# Table name: task_logs
#
#  id         :integer          not null, primary key
#  state      :integer
#  task_id    :integer
#  message    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_task_logs_on_task_id  (task_id)
#

class TaskLog < ApplicationRecord
  belongs_to :task
end
