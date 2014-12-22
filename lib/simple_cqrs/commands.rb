module SimpleCQRS
  DeactivateInventoryItem = Struct.new(:inventory_item_id, :original_version)
  CreateInventoryItem = Struct.new(:inventory_item_id, :name)
  RenameInventoryItem = Struct.new(:inventory_item_id, :new_name, :original_version)
  CheckInItemsToInventory = Struct.new(:inventory_item_id, :count, :original_version)
  RemoveItemsFromInventory = Struct.new(:inventory_item_id, :count, :original_version)
end
