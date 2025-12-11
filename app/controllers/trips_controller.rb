class TripsController < ApplicationController
    before_action :require_login

    def index
        @trips = current_user.trips #arata tripurile unui user
    end

    def new
        @trip = current_user.trips.new #Construiește un trip nou, legat deja de userul curent, dar nu îl salva încă.
    end

    def create
        @trip = Trip.create(
           name: "Trip name", 
           creator_id: current_user.id) #setam creator_id pe trip
        redirect_to trip_path(@trip)
    end

    def show
        @trip = current_user.created_trips.find(params[:id])
    end
    
    private

    def add_participant_to_trip
        participant = User.create(name: "Participant", email_address: "test1@test.com", password: "password1")
        trip = Trip.find(params[:id])

        trip.users << participant
        redirect_to trip_path(trip)
    end

    def only_creator_can_add_participants_to_trip
        trip = Trip.find(params[:id]) #cautam tripul actual
        #verificam daca userul logat este cretorul tripului, apoi redirect

    end
end
