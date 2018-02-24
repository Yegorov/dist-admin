# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  state       :integer          not null
#  creator_id  :integer
#  started_at  :datetime
#  stopped_at  :datetime
#  finished_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_creator_id  (creator_id)
#

class Task < ApplicationRecord
  include TaskState
  belongs_to :creator, class_name: "User"
end
