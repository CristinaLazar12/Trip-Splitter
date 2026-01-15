class TripsController < ApplicationController
    before_action :require_login
    before_action :only_creator_can_add_participants_to_trip, only: [:add_participant]

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

    #def add_participant
        #2 cazuri: cand userul exista, unde doar il adaugam, verificam ca userul a fost adaugat si nu a fost adaugat de 2 ori
        #cazul 2 cand userul nu exista, trebuie creat un user si sa-i trimiti un mail la userul adaugat nou; cand cream un user ii punem o parola random si ii trimitem parola in email, ca sa si-o schimbe; userul il cautam dupa email

        #1. Găsesc tripul
        #2. Caut userul după email
        #3. Dacă userul există:
            #- verific dacă e deja în trip
            #- dacă nu, îl adaug
        #4. Dacă nu există:
            #- creez user
            # - îl adaug

    def add_participant        #de ce metoda nu trebuie sa fie private?
        trip = Trip.find(params[:id]) #cautam tripul
        user = User.find_by(email_address: params[:email_address]) #cautam userul dupa email

        if user.present? #exista userul?
            unless trip.users.include?(user) #daca userul nu e deja inclus
                trip.users << user #il adaugam
            end
        else
            user = User.create(email_address: params[:email_address], name: params[:name], password: SecureRandom.alphanumeric(16)) #userul nu exista, asa ca il cream noi si ii punem o parola random
            trip.users << user #dupa ce userul e creat, il adaugam la trip
        end

        redirect_to trip_path(trip), notice: "Userul a fost creat si adaugat la trip."
    end
        
    private

    def only_creator_can_add_participants_to_trip
        trip = Trip.find(params[:id]) #cautam tripul actual in DB
        unless trip.creator_id == current_user.id #doar daca creatorul tripului nu este la fel ca userul current, 
            redirect_to trip_path(trip), alert: "Nu ai permisiunea sa adaugi participanti la trip." #redirectioneaza la pagina tripului; Dacă NU e creator: îl redirecționezi la pagina tripului oprești efectiv acțiunea (Rails nu mai ajunge la add_participant)
        end
    end
end
