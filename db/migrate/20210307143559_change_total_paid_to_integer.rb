class ChangeTotalPaidToInteger < ActiveRecord::Migration[6.0]
  def change
    change_column :outlets, :total_paid, :integer
  end
end
