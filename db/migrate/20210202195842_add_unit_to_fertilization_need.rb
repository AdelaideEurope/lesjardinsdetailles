class AddUnitToFertilizationNeed < ActiveRecord::Migration[6.0]
  def change
    add_column :fertilization_needs, :unit, :string
  end
end
