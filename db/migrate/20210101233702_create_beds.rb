class CreateBeds < ActiveRecord::Migration[6.0]
  def change
    create_table :beds do |t|
      t.references :garden, null: false, foreign_key: true
      t.string :name
      t.boolean :greenhouse

      t.timestamps
    end
  end
end
