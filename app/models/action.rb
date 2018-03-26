class Action
  extend ActiveModel::Naming
  # include ActiveModel::Model
  @id = nil
  def self.new
    if not @create
      @create = super
    end
    @create
  end
  def self.id
    @id
  end
  def self.title
    name.demodulize
  end
  def self.all(sub = false)
    if sub
      self.subclasses
    else
      self.descendants
    end
  end
  def id
    self.class.id
  end
  def persisted?
    false
  end
  def readonly?
    true
  end
  def name
    self.class.name
  end
  def title
    name.demodulize
  end
  def ==(action)
    self.id == action.id
  end

  class Read < self
    @id = 1
  end
  class Write < self
    @id = 2
  end
  class Create < Write
    @id = 3
  end
  class Update < Write
    @id = 4
  end
  class Remove < Write
    @id = 5
  end
  class Move < self
    @id = 6
  end
  class ChangeOwner < self
    @id = 7
  end
end

