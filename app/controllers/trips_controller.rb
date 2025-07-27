class TripsController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create, :index, :show]

  def index
    if user_signed_in?
      @trips = current_user.trips
    else
      @trips = []
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @response = @trip.openai_response
    @formatted_content = MarkdownRenderer.new.render(@response) if @response.present?
  end

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    if @trip.save
      redirect_to trip_path(@trip), notice: "Trip was successfully created."
    else
      render :new, alert: "Error creating trip."
    end
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :companions, :location, :activity, :extra_information)
  end
end
