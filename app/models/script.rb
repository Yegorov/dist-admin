# == Schema Information
#
# Table name: scripts
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  owner_id   :integer
#  content    :text             default(""), not null
#  mapper     :text             default(""), not null
#  reducer    :text             default(""), not null
#  input      :text             default(""), not null
#  output     :text             default(""), not null
#  language   :integer          default(1), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_scripts_on_owner_id  (owner_id)
#

class Script < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
end
