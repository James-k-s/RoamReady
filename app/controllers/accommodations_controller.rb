class AccommodationsController < ApplicationController
  def index
    @trip = Trip.find(params[:trip_id])
    @lat_lng = @trip.fetch_lat_lng_from_place_id(@trip.place_id)
    if @lat_lng
      @nearby_places = @trip.fetch_nearby_places(@lat_lng["lat"], @lat_lng["lng"], type: "lodging")
    else
      @nearby_places = []
    end
  end
end
