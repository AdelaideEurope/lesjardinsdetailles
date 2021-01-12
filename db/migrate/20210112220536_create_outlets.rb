class CreateOutlets < ActiveRecord::Migration[6.0]
  def change
    create_table :outlets do |t|
      t.string :full_name
      t.string :shortened_name
      t.string :logo
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :email
      t.string :phone_number
      t.integer :ht_turnover
      t.integer :ttc_turnover
      t.string :total_paid_amount
      t.boolean :has_customers
      t.references :outlet_group, null: false, foreign_key: true
      t.references :farm, null: false, foreign_key: true
      t.string :color
      t.string :preferred_payment_method
      t.string :comment
      t.string :invoicing

      t.timestamps
    end
  end
end
