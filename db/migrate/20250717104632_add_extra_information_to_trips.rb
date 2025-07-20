class AddExtraInformationToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :extra_information, :text
  end
end
