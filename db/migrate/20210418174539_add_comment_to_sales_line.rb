class AddCommentToSalesLine < ActiveRecord::Migration[6.0]
  def change
    add_column :sales_lines, :comment, :string
  end
end
