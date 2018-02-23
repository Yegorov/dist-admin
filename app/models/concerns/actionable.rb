module Actionable
  extend ActiveSupport::Concern

  included do
    @@actions = {}
    # Action.subclasses
    Action.descendants.each do |action_class|
      obj = action_class.new
      @@actions[obj.id] = obj

      scope :"instance_of_#{action_class.model_name.element}",
            -> { where(action: action_class.id) }

      scope :"kind_of_#{action_class.model_name.element}",
            -> { where(action: action_class #.descendants.push(action_class)
                              .ancestors
                              .take_while { |klass| klass != Action }
                              .map(&:id)) }
    end
  end

  def action
    @@actions[self[:action]]
  end
  def action=(a)
    if a.instance_of?(Class)
      a = a.new
    end
    if a.is_a?(Action)
      self[:action] = a.id
    elsif a.is_a?(Integer)
      self[:action] = a
    end
  end

  module ClassMethods
    # def new(**kwargs)
    #   if kwargs[:action].instance_of?(Class)
    #     kwargs[:action] = kwargs[:action].new
    #   end
    #   if kwargs[:action].is_a?(Action)
    #     kwargs[:action] = kwargs[:action].id
    #   end
    #   super
    # end    
  end
end

