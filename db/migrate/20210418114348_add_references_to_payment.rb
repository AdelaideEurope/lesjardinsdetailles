class AddReferencesToPayment < ActiveRecord::Migration[6.0]
  def change
    add_reference :payments, :sale, foreign_key: true, null: true
  end
end
