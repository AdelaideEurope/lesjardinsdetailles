class ChangeYieldPerSqmType < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :yield_per_sqm, :decimal
    change_column :products, :yearly_bed_count, :decimal
  end
end
