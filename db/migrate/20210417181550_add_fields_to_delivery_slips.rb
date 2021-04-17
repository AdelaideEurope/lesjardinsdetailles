class AddFieldsToDeliverySlips < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_slips, :outlet_display_name, :string
    add_column :delivery_slips, :outlet_address, :string
    add_column :delivery_slips, :outlet_zip_code, :string
    add_column :delivery_slips, :outlet_zip_city, :string
  end
end
