class CreateVegetableVariets < ActiveRecord::Migration[6.0]
  def change
    create_table :vegetable_variets do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name
      t.string :details

      t.timestamps
    end
  end
end
