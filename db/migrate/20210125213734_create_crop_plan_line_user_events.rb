class CreateCropPlanLineUserEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :crop_plan_line_user_events do |t|
      t.references :crop_plan_line_event, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
