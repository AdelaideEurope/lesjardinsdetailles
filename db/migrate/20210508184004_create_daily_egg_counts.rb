class CreateDailyEggCounts < ActiveRecord::Migration[6.0]
  def change
    create_table :daily_egg_counts do |t|
      t.datetime :date
      t.integer :egg_count

      t.timestamps
    end
  end
end
