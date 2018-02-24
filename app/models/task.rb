# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  state       :integer          default("created"), not null
#  owner_id    :integer
#  started_at  :datetime
#  stopped_at  :datetime
#  finished_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_owner_id  (owner_id)
#

class Task < ApplicationRecord
  include TaskState
  belongs_to :owner, class_name: "User"
  has_many :logs, class_name: 'TaskLog'
end
