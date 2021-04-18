class AddInvoiceReferenceToPayments < ActiveRecord::Migration[6.0]
  def change
    add_reference :payments, :invoice, foreign_key: true, null: true
  end
end
