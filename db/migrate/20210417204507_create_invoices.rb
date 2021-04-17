class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.datetime :date
      t.references :outlet, null: false, foreign_key: true
      t.string :number
      t.integer :ht_total
      t.integer :ttc_total
      t.boolean :sent
      t.string :comment

      t.timestamps
    end
  end
end
