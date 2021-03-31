class CreateDecisions < ActiveRecord::Migration[6.0]
  def change
    create_table :decisions do |t|
      t.datetime :date
      t.string :object
      t.string :details
      t.string :comment
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
