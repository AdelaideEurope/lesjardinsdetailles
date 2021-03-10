class AddUnitToSalesLine < ActiveRecord::Migration[6.0]
  def change
    add_column :sales_lines, :unit, :string
  end
end
