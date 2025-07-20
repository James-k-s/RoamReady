class CreateTrips < ActiveRecord::Migration[7.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.date :start_date
      t.date :end_date
      t.integer :companions
      t.string :location
      t.string :activity
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
