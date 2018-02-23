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

require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
