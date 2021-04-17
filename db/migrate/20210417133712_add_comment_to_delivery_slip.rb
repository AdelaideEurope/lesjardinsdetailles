class AddCommentToDeliverySlip < ActiveRecord::Migration[6.0]
  def change
    add_column :delivery_slips, :comment, :string
  end
end
