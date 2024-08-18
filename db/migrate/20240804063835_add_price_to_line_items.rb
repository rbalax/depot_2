class AddPriceToLineItems < ActiveRecord::Migration[7.1]
  def change
    add_column :line_items, :price, :decimal, precision: 8, scale: 2
    LineItem.all.each do |line_item|
      line_item.update_column(:price, line_item.product.price)
    end
  end
end
