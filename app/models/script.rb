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
# Foreign Keys
#
#  fk_rails_...  (owner_id => users.id)
#

class Script < ApplicationRecord
  enum language: { python: 1, ruby: 2, go: 3, javascript: 4 }

  belongs_to :owner, class_name: "User"
  has_many :tasks, dependent: :nullify

  validates :name, :mapper, :reducer, :input, presence: true
  validate do |script|
    [:input, :output].each do |column|
      if script.read_attribute(column).present?
        value = script.read_attribute(column)
        unless value =~ /[\w\d]+:\d+/
          errors.add(column, 'must be in format "login:iid", example: "user1:3"')
        end
      end
    end
  end

  scope :owned, ->(user){ where(owner: user) }

  paginates_per 20

end
