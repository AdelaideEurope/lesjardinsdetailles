class RemoveTotalPaidAmountFromOutlet < ActiveRecord::Migration[6.0]
  def change
    remove_column :outlets, :total_paid_amount, :string
  end
end
