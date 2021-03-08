class CreateSalesLines < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_lines do |t|
      t.date :date
      t.references :bed, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :ht_unit_price, default: 0
      t.integer :ttc_unit_price, default: 0
      t.integer :ht_total, default: 0
      t.integer :ttc_total, default: 0
      t.references :sale, null: false, foreign_key: true

      t.timestamps
    end
  end
end
