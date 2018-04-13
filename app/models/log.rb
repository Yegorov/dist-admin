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

class Log < ApplicationRecord
end
