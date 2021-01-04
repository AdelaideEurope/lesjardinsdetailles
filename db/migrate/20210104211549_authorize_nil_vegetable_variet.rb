class AuthorizeNilVegetableVariet < ActiveRecord::Migration[6.0]
  def change
    change_column :crop_plan_lines, :vegetable_variet_id, :bigint, null:true
  end
end
