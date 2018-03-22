# == Schema Information
#
# Table name: tasks
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  state       :integer          default("created"), not null
#  prepared    :boolean          default(TRUE), not null
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

class Task < ApplicationRecord
  include TaskState
  belongs_to :owner, class_name: "User"
  belongs_to :script
  has_many :logs, class_name: 'TaskLog', dependent: :delete_all

  validates :name, presence: true
  validate on: :create do |task|
    if task.owner.present? && task.script.present?
      owner = task.owner
      script = task.script
      unless script.owner_id == owner.id # owner.scripts.include?(script)
        errors.add(:base, 'Script must be writing by task owner')
      end
    end
  end

  # running (or strted) tasks
  scope :launched, ->{ where(state: :started) }
  # finished tasks
  scope :completed, ->{ where(state: :finished) }

  scope :owned, ->(user) { where(owner: user) }
  scope :prepared, -> { where(prepared: true) }

  state_machine :state, attribute: :state, initial: :created do
    # state :created, value: 0
    # Task.states.each do |state_name, value|
    #   state :"state_name", value: value
    # end

    before_transition do |task, transition|
      task.update_column(:prepared, false)
    end

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

    after_transition on: :start, do: :start_task

    event :start do
      transition created: :started, if: :prepared?
    end

    event :stop do
      transition started: :stopped, if: :prepared?
    end

    event :restart do
      transition stopped: :started, if: :prepared?
    end

    event :finish do
      transition started: :finished, if: :prepared?
    end
  end

  def start_task
    puts "Run real hadoop task" # call in Task manager TastManager.start
    # process id, stdout hadoop task
  end

  def running_time
    finished_at.try do |finish|
      started_at.try do |start|
        finish - start
      end
    end
  end

  def prepared!
    # need call when real task ready
    self.update_column(:prepared, true)
  end

end
