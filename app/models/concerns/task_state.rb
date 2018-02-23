module TaskState
  extend ActiveSupport::Concern

  included do
    enum state: { 
      created: 0,
      started: 1, 
      stopped: 4, 
      restarted: 5, 
      finished: 6
    }
  end
end
