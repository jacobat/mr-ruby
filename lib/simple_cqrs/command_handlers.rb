module SimpleCQRS
  class InventoryCommandHandlers
    attr_reader :repository
    def initialize(repository)
      @repository = repository
    end

    def handle(command)
      case command
      when CreateInventoryItem
        item = InventoryItem.new(command.inventory_item_id, command.name)
        repository.save(item, -1)
      when DeactivateInventoryItem
        item = repository.get_by_id(command.inventory_item_id)
        item.deactivate
        repository.save(item, command.original_version)
      when RemoveItemsFromInventory
        item = repository.get_by_id(command.inventory_item_id)
        item.remove(command.count)
        repository.save(item, command.original_version)
      when CheckInItemsToInventory
        item = repository.get_by_id(command.inventory_item_id)
        item.check_in(command.count);
        repository.save(item, command.original_version)
      when RenameInventoryItem
        item = repository.get_by_id(command.inventory_item_id)
        item.change_name(command.new_name);
        repository.save(item, command.original_version)
      end
    end
  end
end
