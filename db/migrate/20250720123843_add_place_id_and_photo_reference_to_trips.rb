class AddPlaceIdAndPhotoReferenceToTrips < ActiveRecord::Migration[7.1]
  def change
    add_column :trips, :place_id, :string
    add_column :trips, :place_photo_reference, :string
  end
end
