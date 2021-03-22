class ChangeQuantityTypeToDecimal < ActiveRecord::Migration[6.0]
  def change
    change_column :sales_lines, :quantity, :decimal
  end
end
