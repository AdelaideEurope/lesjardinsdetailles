class RemoveInvoiceFromPayments < ActiveRecord::Migration[6.0]
  def change
    remove_reference :payments, :invoice, null: false, foreign_key: true
  end
end
