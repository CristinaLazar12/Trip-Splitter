class TripsController < ApplicationController
  before_action :require_login
  before_action :set_trip, only: [:show, :add_participant]
  before_action :only_creator_can_add_participants_to_trip, only: [:add_participant]

  def index
    @trips = current_user.created_trips
  end

  def new
    @trip = current_user.created_trips.build
  end

  def create
    @trip = current_user.created_trips.build(trip_params)

    if @trip.save
      redirect_to @trip
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # @trip is already set by set_trip
  end

  def add_participant
    user = User.find_by(email_address: params[:email_address])

    if user.present?
      @trip.users << user unless @trip.users.include?(user)
    else
      user = User.create(
        email_address: params[:email_address],
        name: params[:name],
        password: SecureRandom.alphanumeric(16)
      )
      @trip.users << user
    end

    redirect_to @trip, notice: "Userul a fost creat si adaugat la trip."
  end

  private

  def set_trip
    @trip = current_user.created_trips.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:name)
  end

  def only_creator_can_add_participants_to_trip
    # acum @trip există deja
    unless @trip.creator_id == current_user.id
      redirect_to @trip, alert: "Nu ai permisiunea sa adaugi participanti la trip."
    end
  end
end
