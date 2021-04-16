class ChangeDecimalForIntegersBasket < ActiveRecord::Migration[6.0]
  def change
    change_column :baskets, :ht_price, :integer
    change_column :baskets, :ttc_price, :integer
    change_column :baskets, :ht_actual_total, :integer
    change_column :baskets, :ttc_actual_total, :integer
  end
end
