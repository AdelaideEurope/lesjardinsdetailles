class AddDefaultToProduct < ActiveRecord::Migration[6.0]
  def change
    change_column_default :products, :ht_turnover, from: nil, to: 0
    change_column_default :products, :ttc_turnover, from: nil, to: 0
  end
end
