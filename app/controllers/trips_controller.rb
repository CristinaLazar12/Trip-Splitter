class TripsController < ApplicationController
  before_action :require_login
  before_action :set_trip, only: [:add_participant, :remove_participant]

  def index
    @trips = current_user.created_trips
  end

  def new
    @trip = current_user.created_trips.build
  end

  def create
    @trip = current_user.created_trips.build(trip_params)

    if @trip.save
      @trip.users << current_user
      redirect_to @trip
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show 
    @trip = Trip.find(params[:id])
    @expenses = @trip.expenses
  end

  def edit
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])

    if @trip.update(trip_params)
      redirect_to @trip, notice: "Trip updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip = Trip.find_by(id: params[:id])
      return redirect_to dashboard_path, alert: "Trip not found." unless @trip

      unless @trip.creator == current_user
        return redirect_to dashboard_path, alert: "You can't delete a trip you didn't create."
      end

    @trip.destroy
      redirect_to dashboard_path, notice: "Trip deleted successfully."
  end

  def add_participant
    user = User.find_by(email_address: params[:email_address])

    authorize @trip, :add_participant?

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

    redirect_to @trip, notice: "Participantul a fost adaugat la trip."
  rescue Pundit::NotAuthorizedError => e
    redirect_to @trip, alert: "Nu ai permisiunea sa adaugi participanti la trip."
  end

  def remove_participant
    user = User.find_by(id: params[:user_id])

    authorize @trip, :remove_participant?
    
    @trip.users.delete(user)

    redirect_to @trip, notice: "Participantul a fost sters."
  rescue Pundit::NotAuthorizedError => e
    redirect_to @trip, alert: "Nu ai permisiunea sa stergi participanti la trip."
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
