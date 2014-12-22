class ItemsController < ApplicationController
  def index
    readmodel = SimpleCQRS::ReadModelFacade.new($db)
    @items = readmodel.get_inventory_items.list
  end

  def show
  end

  def new
  end

  def details
    @item = fetch_item
  end

  def create
    uuid = SecureRandom.uuid
    $bus.send_command(SimpleCQRS::CreateInventoryItem.new(uuid, params[:name]))
    redirect_to items_path
  end

  def check_in
    @item = fetch_item
  end

  def perform_check_in
    $bus.send_command(SimpleCQRS::CheckInItemsToInventory.new(params[:id], params[:count].to_i, params[:version].to_i))
    redirect_to items_path
  end

  def remove
    @item = fetch_item
  end

  def perform_remove
    $bus.send_command(SimpleCQRS::RemoveItemsFromInventory.new(params[:id], params[:count].to_i, params[:version].to_i))
    redirect_to items_path
  end

  def rename
    @item = fetch_item
  end

  def perform_rename
    $bus.send_command(SimpleCQRS::RenameInventoryItem.new(params[:id], params[:new_name], params[:version].to_i))
    redirect_to items_path
  end

  def deactivate
    $bus.send_command(SimpleCQRS::DeactivateInventoryItem.new(params[:id], params[:version].to_i))
    redirect_to items_path
  end

  private

  def fetch_item
    readmodel.get_inventory_item_details(params[:id])
  end

  def readmodel
    SimpleCQRS::ReadModelFacade.new($db)
  end
end
