class AddCommentToCropPlanLineEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :crop_plan_line_events, :comment, :string
  end
end
