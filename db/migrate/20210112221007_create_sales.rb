class CreateSales < ActiveRecord::Migration[6.0]
  def change
    create_table :sales do |t|
      t.datetime :date
      t.references :outlet, null: false, foreign_key: true
      t.integer :ht_total
      t.integer :ttc_total
      t.integer :rounded_ht_total
      t.integer :rounded_ttc_total
      t.boolean :recurrent
      t.string :frequency
      t.string :comment

      t.timestamps
    end
  end
end
