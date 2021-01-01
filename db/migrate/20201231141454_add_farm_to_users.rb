class AddFarmToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :farm, null: false, foreign_key: true
  end
end
