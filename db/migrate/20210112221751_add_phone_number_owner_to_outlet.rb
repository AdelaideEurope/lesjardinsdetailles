class AddPhoneNumberOwnerToOutlet < ActiveRecord::Migration[6.0]
  def change
    add_column :outlets, :phone_number_owner, :string
  end
end
