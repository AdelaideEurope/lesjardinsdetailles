class CreateFarms < ActiveRecord::Migration[6.0]
  def change
    create_table :farms do |t|
      t.string :full_name
      t.string :shortened_name
      t.string :logo
      t.string :address
      t.string :zip_code
      t.string :city
      t.string :siret
      t.integer :ttc_turnover, default: 0
      t.integer :ht_turnover, default: 0
      t.integer :estimated_ttc_turnover, default: 0
      t.integer :estimated_ht_turnover, default: 0

      t.timestamps
    end
  end
end
