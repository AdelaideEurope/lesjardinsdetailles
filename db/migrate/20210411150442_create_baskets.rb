class CreateBaskets < ActiveRecord::Migration[6.0]
  def change
    create_table :baskets do |t|
      t.string :name
      t.date :date
      t.references :sale, null: false, foreign_key: true
      t.integer :ht_price
      t.integer :ttc_price
      t.integer :quantity
      t.boolean :confirmed
      t.boolean :recurrent
      t.string :frequency
      t.integer :cumulated_difference

      t.timestamps
    end
  end
end
