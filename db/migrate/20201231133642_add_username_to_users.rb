class AddUsernameToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :string, default: "F"
    add_column :users, :manager, :boolean, default: false
    add_column :users, :worker, :boolean, default: false
    add_column :users, :admin, :boolean, default: false
    add_column :users, :picture, :string
    add_column :users, :color, :string
  end
end
