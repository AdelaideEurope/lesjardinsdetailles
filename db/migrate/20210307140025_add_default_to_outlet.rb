class AddDefaultToOutlet < ActiveRecord::Migration[6.0]
  def change
    change_column_default :outlets, :ht_turnover, from: nil, to: 0
    change_column_default :outlets, :ttc_turnover, from: nil, to: 0
    change_column_default :outlets, :total_paid_amount, from: nil, to: 0
  end
end
