module SimpleCQRS
  InventoryItemDetailsDto = Struct.new(:id, :name, :current_count, :version)
  InventoryItemListDto = Struct.new(:id, :name)

  class InventoryListView
    def initialize(database)
      @database = database
    end

    def handle(event)
      case event
      when InventoryItemCreated
        @database.list.add(InventoryItemListDto.new(event.id, event.name))
      when InventoryItemRenamed
        item = @database.list.find(event.id)
        item.name = event.new_name;
      when InventoryItemDeactivated
        @database.list.remove_all(event.id)
      end
    end
  end

  class InventoryItemDetailView
    def initialize(database)
      @database = database
    end

    def handle(event)
      case event
      when InventoryItemCreated
        @database.details.add(event.id, InventoryItemDetailsDto.new(event.id, event.name, 0,0))
      when InventoryItemRenamed
        d = get_details_item(event.id)
        d.name = event.new_name
        d.version = event.version
      when ItemsRemovedFromInventory
        d = get_details_item(event.id)
        d.current_count -= event.count
        d.version = event.version
      when ItemsCheckedInToInventory
        d = get_details_item(event.id)
        d.current_count += event.count
        d.version = event.version
      when InventoryItemDeactivated
        @database.details.remove(event.id)

      end
    end

    private

    def get_details_item(id)
      @database.details.fetch(id)
    end
  end

  class ReadModelFacade
    def initialize(database)
      @database = database
    end

    def get_inventory_items
      @database.list
    end

    def get_inventory_item_details(id)
      @database.details.fetch(id)
    end
  end

  class Details
    def initialize
      @details = {}
    end

    def add(id, dto)
      @details[id] = dto
    end

    def get(id)
      @details[id]
    end

    def fetch(id)
      @details.fetch(id)
    end

    def remove(id)
      @details.delete(id)
    end
  end

  class ItemList
    attr_reader :list

    def initialize
      @list = []
    end
    
    def find(id)
      @list.find{|item| item.id == id}
    end

    def add(item)
      list << item
    end

    def remove_all(id)
      item = find(id)
      list.delete(item)
    end
  end

  class BullShitDatabase
    attr_reader :details, :list
    def initialize
      @details = Details.new
      @list = ItemList.new
    end
  end
end
