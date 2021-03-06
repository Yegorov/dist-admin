# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  state       :integer          default("created"), not null
#  prepared    :boolean          default(TRUE), not null
#  unix_pid    :string           default(""), not null
#  owner_id    :integer
#  script_id   :integer
#  started_at  :datetime
#  stopped_at  :datetime
#  finished_at :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_tasks_on_owner_id   (owner_id)
#  index_tasks_on_script_id  (script_id)
#
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#  fk_rails_...  (script_id => scripts.id) ON DELETE => nullify
#

require 'rails_helper'

RSpec.describe Task, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
