class AddInitialDatePlannedToCropPlanLineEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :crop_plan_line_events, :initial_date_planned, :datetime
  end
end
