class TripsController < ApplicationController
    before_action :require_login

    def index
        @trips = current_user.trips #arata tripurile unui user
    end

    def new
        @trip = current_user.trips.new #Construiește un trip nou, legat deja de userul curent, dar nu îl salva încă.
    end

    def create
        @trip = current_user.trips.create(name: "Trip name", user_id: current_user.id)
        @trip.creator_id = current_user.id

        redirect_to trip_path(@trip)
    end

    def show
        @trip = current_user.trips.find(params[:id])
    end
    
    private

    def add_participant_to_trip
    end

    def only_owner_can_add_participants
    end
end
