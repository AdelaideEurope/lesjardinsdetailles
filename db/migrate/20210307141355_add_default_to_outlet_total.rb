class AddDefaultToOutletTotal < ActiveRecord::Migration[6.0]
  def change
    change_column_default :outlets, :total_paid, from: nil, to: 0
  end
end
