class AddInvoiceToSale < ActiveRecord::Migration[6.0]
  def change
    add_reference :sales, :invoice, foreign_key: true
  end
end
