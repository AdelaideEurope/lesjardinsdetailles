class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.datetime :date
      t.string :description
      t.string :details
      t.string :comment
      t.string :event_category
      t.string :event_subcategory
      t.datetime :date_done
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
