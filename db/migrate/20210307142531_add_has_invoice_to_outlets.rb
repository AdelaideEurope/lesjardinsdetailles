class AddHasInvoiceToOutlets < ActiveRecord::Migration[6.0]
  def change
    add_column :outlets, :has_invoice, :boolean, default: false
  end
end
