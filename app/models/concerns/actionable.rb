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

    scope :action, ->(a) do
      if a.kind_of?(Action)
        send("kind_of_#{a.class.model_name.element}")
      elsif a.kind_of?(Integer)
        if @@actions.fetch(a, nil).nil?
          raise "Unknown action with id=#{a}"
        end
        send("kind_of_#{@@actions[a].class.model_name.element}")
      else
        send("kind_of_#{a.model_name.element}")
      end
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

  Action.descendants.each do |action_class|
    define_method :"allow_#{action_class.model_name.element}?" do
      self.action == action_class || self.action.class.descendants.include?(action_class)
    end
  end

  define_method :"allow?" do |a|
    if a.kind_of?(Action)
      send("allow_#{a.class.model_name.element}?")
    elsif a.kind_of?(Integer)
      if @@actions.fetch(a, nil).nil?
        raise "Unknown action with id=#{a}"
      end
      send("allow_#{@@actions[a].class.model_name.element}?")
    else
      send("allow_#{a.model_name.element}?")
    end
  end

  module ClassMethods
    def actions
      self.class_variable_get('@@actions')
    end
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

