class AddQuantityToSalesLine < ActiveRecord::Migration[6.0]
  def change
    add_column :sales_lines, :quantity, :integer, default: 0
  end
end
