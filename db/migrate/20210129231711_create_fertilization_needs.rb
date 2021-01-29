class CreateFertilizationNeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :fertilization_needs do |t|
      t.references :product, null: false, foreign_key: true
      t.string :type
      t.integer :quantity

      t.timestamps
    end
  end
end
