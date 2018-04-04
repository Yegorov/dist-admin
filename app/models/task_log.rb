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
# Foreign Keys
#
#  fk_rails_...  (task_id => tasks.id)
#

class TaskLog < ApplicationRecord
  include TaskState
  belongs_to :task

  scope :by_task, ->(task) { where(task: task) }

  paginates_per 5
end
