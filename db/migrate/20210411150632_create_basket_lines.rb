class CreateBasketLines < ActiveRecord::Migration[6.0]
  def change
    create_table :basket_lines do |t|
      t.date :date
      t.references :basket, null: false, foreign_key: true
      t.integer :ht_unit_price
      t.integer :ttc_unit_price
      t.decimal :quantity
      t.integer :ht_total_price
      t.integer :ttc_total_price
      t.string :unit
      t.references :bed, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
