class AddCommentToPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :comment, :string
  end
end
