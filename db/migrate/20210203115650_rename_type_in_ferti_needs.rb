class RenameTypeInFertiNeeds < ActiveRecord::Migration[6.0]
  def change
    rename_column :fertilization_needs, :type, :fertilization_type
  end
end
