class AddTotalPaidToOutlets < ActiveRecord::Migration[6.0]
  def change
    add_column :outlets, :total_paid, :decimal
  end
end
