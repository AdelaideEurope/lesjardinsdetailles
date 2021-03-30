class CreateHenActions < ActiveRecord::Migration[6.0]
  def change
    create_table :hen_actions do |t|
      t.datetime :date
      t.string :action
      t.string :comment
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
