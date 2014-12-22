$bus = SimpleCQRS::FakeBus.new
$db = SimpleCQRS::BullShitDatabase.new

storage = SimpleCQRS::EventStore.new($bus)
rep = $rep = SimpleCQRS::Repository.new(storage, SimpleCQRS::InventoryItem)
commands = SimpleCQRS::InventoryCommandHandlers.new(rep)
$bus.register_command_handler(SimpleCQRS::CheckInItemsToInventory, SimpleCQRS::InventoryCommandHandlers.new(rep))
$bus.register_command_handler(SimpleCQRS::CreateInventoryItem, SimpleCQRS::InventoryCommandHandlers.new(rep))
$bus.register_command_handler(SimpleCQRS::DeactivateInventoryItem, SimpleCQRS::InventoryCommandHandlers.new(rep))
$bus.register_command_handler(SimpleCQRS::RemoveItemsFromInventory, SimpleCQRS::InventoryCommandHandlers.new(rep))
$bus.register_command_handler(SimpleCQRS::RenameInventoryItem, SimpleCQRS::InventoryCommandHandlers.new(rep))
detail = SimpleCQRS::InventoryItemDetailView.new($db)
$bus.register_event_handler(SimpleCQRS::InventoryItemCreated, detail)
$bus.register_event_handler(SimpleCQRS::InventoryItemDeactivated, detail)
$bus.register_event_handler(SimpleCQRS::InventoryItemRenamed, detail)
$bus.register_event_handler(SimpleCQRS::ItemsCheckedInToInventory, detail)
$bus.register_event_handler(SimpleCQRS::ItemsRemovedFromInventory, detail)
list = SimpleCQRS::InventoryListView.new($db)
$bus.register_event_handler(SimpleCQRS::InventoryItemCreated, list)
$bus.register_event_handler(SimpleCQRS::InventoryItemRenamed, list)
$bus.register_event_handler(SimpleCQRS::InventoryItemDeactivated, list)
# ServiceLocator.Bus = bus
