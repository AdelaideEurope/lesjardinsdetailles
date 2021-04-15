class ChangeBasketPricesType < ActiveRecord::Migration[6.0]
  def change
    change_column :baskets, :ht_price, :decimal
    change_column :baskets, :ttc_price, :decimal
  end
end
