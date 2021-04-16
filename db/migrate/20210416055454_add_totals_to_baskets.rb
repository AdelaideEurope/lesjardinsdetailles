class AddTotalsToBaskets < ActiveRecord::Migration[6.0]
  def change
    add_column :baskets, :ht_actual_total, :decimal
    add_column :baskets, :ttc_actual_total, :decimal
  end
end
