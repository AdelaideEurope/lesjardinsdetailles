class AddStartTimeToPresencePeriods < ActiveRecord::Migration[6.0]
  def change
    add_column :presence_periods, :start_time, :datetime
    add_column :presence_periods, :end_time, :datetime
  end
end
