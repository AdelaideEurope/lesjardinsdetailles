class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :simplified_name
      t.string :type
      t.string :general_unit
      t.integer :general_price_final_client
      t.integer :general_price_intermediary
      t.integer :yearly_bed_count
      t.integer :yield_per_sqm
      t.integer :estimated_turnover
      t.references :farm, null: false, foreign_key: true
      t.references :product_group, null: false, foreign_key: true
      t.string :color
      t.integer :spacing
      t.integer :row_count
      t.integer :loss_percentage
      t.integer :growth_duration_in_weeks
      t.integer :harvest_duration_in_weeks
      t.integer :ht_turnover
      t.integer :ttc_turnover
      t.string :picture

      t.timestamps
    end
  end
end
