class AddDataToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :outlet_display_name, :string
    add_column :invoices, :outlet_address, :string
    add_column :invoices, :outlet_zip_code, :string
    add_column :invoices, :outlet_city, :string
  end
end
