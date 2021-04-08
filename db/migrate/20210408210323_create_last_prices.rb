class CreateLastPrices < ActiveRecord::Migration[6.0]
  def change
    create_table :last_prices do |t|
      t.text :amount, array: true, default: []
      t.text :unit, array: true, default: []
      t.references :product, null: false, foreign_key: true
      t.references :outlet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
