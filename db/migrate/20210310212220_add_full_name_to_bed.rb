class AddFullNameToBed < ActiveRecord::Migration[6.0]
  def change
    add_column :beds, :full_name, :string
  end
end
