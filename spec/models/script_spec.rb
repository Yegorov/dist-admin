# == Schema Information
#
# Table name: scripts
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  owner_id    :integer
#  description :text             default(""), not null
#  mapper      :text             default(""), not null
#  reducer     :text             default(""), not null
#  input       :text             default(""), not null
#  output      :text             default(""), not null
#  language    :integer          default("python"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_scripts_on_owner_id  (owner_id)
#

require 'rails_helper'

RSpec.describe Script, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
