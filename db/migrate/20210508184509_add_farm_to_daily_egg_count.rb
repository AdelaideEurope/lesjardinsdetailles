class AddFarmToDailyEggCount < ActiveRecord::Migration[6.0]
  def change
    add_reference :daily_egg_counts, :farm, foreign_key: true
  end
end
