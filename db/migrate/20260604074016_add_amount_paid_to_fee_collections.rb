class AddAmountPaidToFeeCollections < ActiveRecord::Migration[8.1]
  def change
    add_column :fee_collections, :amount_paid, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :fee_collections, :remaining_amount, :decimal, precision: 10, scale: 2, default: 0.0
  end
end
