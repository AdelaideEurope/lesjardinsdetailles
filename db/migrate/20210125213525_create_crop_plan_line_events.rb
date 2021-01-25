class CreateCropPlanLineEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :crop_plan_line_events do |t|
      t.references :crop_plan_line, null: false, foreign_key: true
      t.boolean :different_from_original
      t.datetime :date_done
      t.datetime :date_planned
      t.string :name

      t.timestamps
    end
  end
end
