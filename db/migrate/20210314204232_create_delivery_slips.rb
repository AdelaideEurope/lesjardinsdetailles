class CreateDeliverySlips < ActiveRecord::Migration[6.0]
  def change
    create_table :delivery_slips do |t|
      t.references :sale, null: false, foreign_key: true
      t.date :date
      t.string :number
      t.integer :ht_total
      t.integer :ttc_total
      t.boolean :confirmed

      t.timestamps
    end
  end
end
