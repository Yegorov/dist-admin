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

  state_machine :state, attribute: :state, initial: :created do
    # state :created, value: 0
    # Task.states.each do |state_name, value|
    #   state :"state_name", value: value
    # end

    after_transition do |task, transition|
      # add to log
      task.logs.create(state: transition.to,
                       message: "Change state from '#{transition.from}' state "\
                                "to '#{transition.to}' state")
    end

    after_transition any => all - [:restarted] do |task, transition|
      # update time
      task.update_column(:"#{transition.to}_at", Time.zone.now)
    end

    after_transition stopped: :restarted { |task| task.start }

    after_transition on: :start, do: :start_task

    event :start do
      transition created: :started
      transition restarted: :started
    end

    event :stop do
      transition started: :stopped
    end

    event :restart do
      transition stopped: :restarted
    end

    event :finish do
      transition started: :finished
    end
  end

  def start_task
    puts "Run real hadoop task" # call in Task manager TastManager.start
    # process id, stdout hadoop task
  end
end
