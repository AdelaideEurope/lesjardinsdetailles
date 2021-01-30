class CreateNewsletterSubscribers < ActiveRecord::Migration[6.0]
  def change
    create_table :newsletter_subscribers do |t|
      t.references :farm, null: false, foreign_key: true
      t.string :first_name
      t.string :email

      t.timestamps
    end
  end
end
