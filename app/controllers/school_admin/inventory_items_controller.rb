module SchoolAdmin
  class InventoryItemsController < BaseController
    include SchoolScope

    def index
      @items = scope_query(InventoryItem).order(:name)
      @items = @items.where(category: params[:category]) if params[:category].present?
      @low_stock = @items.low_stock.count
    end

    def new
      @item = InventoryItem.new
    end

    def create
      @item = scope_query(InventoryItem).new(item_params)
      if @item.save
        redirect_to school_admin_inventory_items_path, notice: "Item added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @item = scope_query(InventoryItem).find(params[:id])
    end

    def update
      @item = scope_query(InventoryItem).find(params[:id])
      if @item.update(item_params)
        redirect_to school_admin_inventory_items_path, notice: "Item updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @item = scope_query(InventoryItem).find(params[:id])
      @item.destroy
      redirect_to school_admin_inventory_items_path, notice: "Item removed."
    end

    private

    def item_params
      params.require(:inventory_item).permit(:name, :category, :description, :quantity, :unit, :condition, :purchase_date, :purchase_price, :status)
    end
  end
end
