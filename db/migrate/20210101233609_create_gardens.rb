class CreateGardens < ActiveRecord::Migration[6.0]
  def change
    create_table :gardens do |t|
      t.string :name
      t.references :farm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
