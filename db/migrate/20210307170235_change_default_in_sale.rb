class ChangeDefaultInSale < ActiveRecord::Migration[6.0]
  def change
    change_column_default :sales, :ht_total, from: nil, to: 0
    change_column_default :sales, :ttc_total, from: nil, to: 0
    change_column_default :sales, :rounded_ht_total, from: nil, to: 0
    change_column_default :sales, :rounded_ttc_total, from: nil, to: 0
  end
end
