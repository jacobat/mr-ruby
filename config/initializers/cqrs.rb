require 'simple_cqrs'

$bus = SimpleCQRS::FakeBus.new
$db = SimpleCQRS::BullShitDatabase.new

storage = SimpleCQRS::EventStore.new($bus)
rep = $rep = SimpleCQRS::Repository.new(storage, SimpleCQRS::InventoryItem)

commands = SimpleCQRS::InventoryCommandHandlers.new(rep)
$bus.register_command_handler(SimpleCQRS::CheckInItemsToInventory, commands)
$bus.register_command_handler(SimpleCQRS::CreateInventoryItem, commands)
$bus.register_command_handler(SimpleCQRS::DeactivateInventoryItem, commands)
$bus.register_command_handler(SimpleCQRS::RemoveItemsFromInventory, commands)
$bus.register_command_handler(SimpleCQRS::RenameInventoryItem, commands)

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
