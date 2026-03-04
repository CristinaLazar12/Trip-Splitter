module TripsHelper
    def trip_creator?(trip)
        trip.creator_id == current_user.id 
    end
end
