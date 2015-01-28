module SimpleCQRS
  class Event
    attr_accessor :version

    def initialize
      @time = Time.now
    end
  end

  class InventoryItemDeactivated < Event
    attr_reader :id

    def initialize(id)
      super()
      @id = id
    end
  end

  class InventoryItemCreated < Event
    attr_reader :id, :name

    def initialize(id, name)
      super()
      @id = id
      @name = name
    end
  end

  class InventoryItemRenamed < Event
    attr_reader :id, :new_name

    def initialize(id, new_name)
      super()
      @id = id
      @new_name = new_name
    end
  end

  class ItemsCheckedInToInventory < Event
    attr_reader :id, :count

    def initialize(id, count)
      super()
      @id = id
      @count = count
    end
  end

  class ItemsRemovedFromInventory < Event
    attr_reader :id, :count

    def initialize(id, count)
      super()
      @id = id
      @count = count
    end
  end
end
