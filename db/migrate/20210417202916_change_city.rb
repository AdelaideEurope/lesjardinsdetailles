class ChangeCity < ActiveRecord::Migration[6.0]
  def change
    rename_column :delivery_slips, :outlet_zip_city, :outlet_city
  end
end
