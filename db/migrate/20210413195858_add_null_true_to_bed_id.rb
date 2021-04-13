class AddNullTrueToBedId < ActiveRecord::Migration[6.0]
  def change
    change_column_null :basket_lines, :bed_id, true
  end
end
