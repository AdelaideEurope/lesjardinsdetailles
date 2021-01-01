class CreateCropPlanLines < ActiveRecord::Migration[6.0]
  def change
    create_table :crop_plan_lines do |t|
      t.date :planting_date
      t.date :harvest_start_date
      t.date :harvest_end_date
      t.references :bed, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :meter_count
      t.string :seedling_type
      t.string :comment
      t.boolean :different_from_original
      t.references :vegetable_variet, null: false, foreign_key: true
      t.integer :estimated_turnover

      t.timestamps
    end
  end
end
