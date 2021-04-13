class AddCommentToBasket < ActiveRecord::Migration[6.0]
  def change
    add_column :baskets, :comment, :string
  end
end
