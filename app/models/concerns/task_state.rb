module TaskState
  extend ActiveSupport::Concern

  included do
    enum state: { 
      created: 0,
      started: 1, 
      stopped: 2,
      finished: 3
    }, _prefix: :state
  end
end
