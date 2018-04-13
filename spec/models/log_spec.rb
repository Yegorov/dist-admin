# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  message    :text             default("")
#  status     :string           default("info"), not null
#  subject    :string           default("unknown"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Log, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
