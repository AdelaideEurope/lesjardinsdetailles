class CreateOutletGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :outlet_groups do |t|
      t.string :name
      t.string :color
      t.integer :ht_turnover
      t.integer :ttc_turnover

      t.timestamps
    end
  end
end
