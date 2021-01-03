class CreatePresencePeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :presence_periods do |t|
      t.datetime :date
      t.boolean :on_call_period
      t.string :comment
      t.string :moment_in_day
      t.boolean :specific_moment

      t.timestamps
    end
  end
end
