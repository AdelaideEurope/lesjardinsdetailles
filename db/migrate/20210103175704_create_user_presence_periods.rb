class CreateUserPresencePeriods < ActiveRecord::Migration[6.0]
  def change
    create_table :user_presence_periods do |t|
      t.references :user, null: false, foreign_key: true
      t.references :presence_period, null: false, foreign_key: true

      t.timestamps
    end
  end
end
