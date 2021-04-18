class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer :paid_amount
      t.references :outlet, null: false, foreign_key: true
      t.string :payment_method
      t.datetime :date
      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
