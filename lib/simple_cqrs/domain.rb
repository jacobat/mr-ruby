module SimpleCQRS
  class AggregateRoot
    attr_reader :id, :version

    def initialize
      @changes = []
      @id = nil
      @version = nil
    end

    def get_uncommitted_changes
      @changes
    end

    def mark_changes_as_committed
      @changes = []
    end

    def load_from_history(history)
      history.each do |event|
        apply_change(event, false)
      end
    end

    private

    def apply_change(event, is_new = true)
      apply(event)
      @changes << event if is_new
    end
  end

  class InventoryItem < AggregateRoot
    attr_reader :id

    def initialize(id = nil, name = nil)
      super()
      if id && name
        apply_change(InventoryItemCreated.new(id, name))
      end
    end

    def apply(event) # InventoryItemCreated
      case event
      when InventoryItemCreated
        @id = event.id
        @activated = true
      when InventoryItemDeactivated
        @activated = false
      end
    end

    def change_name(new_name)
      raise ArgumentException("new_name") if new_name.nil? || new_name.empty?
      apply_change(InventoryItemRenamed.new(@id, new_name))
    end

    def remove(count)
      raise "cant remove negative count from inventory" if count <= 0
      apply_change(ItemsRemovedFromInventory.new(@id, count))
    end

    def check_in(count)
      raise "must have a count greater than 0 to add to inventory" if(count <= 0)
      apply_change(ItemsCheckedInToInventory.new(@id, count))
    end

    def deactivate
      raise "already deactivated" if(!@activated)
      apply_change(InventoryItemDeactivated.new(@id));
    end
  end

  class Repository
    def initialize(storage, aggregate_class)
      @storage = storage
      @aggregate_class = aggregate_class
    end

    def save(aggregate, expected_version)
      @storage.save_events(aggregate.id, aggregate.get_uncommitted_changes, expected_version)
      aggregate.mark_changes_as_committed
    end

    def get_by_id(id)
      events = @storage.get_events_for_aggregate(id)
      object = @aggregate_class.new
      object.load_from_history(events)
      object
    end

    def events_for(id)
      @storage.get_events_for_aggregate(id)
    end

    def root_ids
      @storage.root_ids
    end
  end
end
