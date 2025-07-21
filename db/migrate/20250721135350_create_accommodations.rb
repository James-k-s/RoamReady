class CreateAccommodations < ActiveRecord::Migration[7.1]
  def change
    create_table :accommodations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :booking_url
      t.string :address
      t.references :trip, null: false, foreign_key: true
      t.boolean :booked

      t.timestamps
    end
  end
end
