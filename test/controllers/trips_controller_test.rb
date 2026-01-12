require "test_helper"

class TripsControllerTest < ActionDispatch::IntegrationTest

    setup do
        @trip  = trips(:one)
        @user  = users(:one)
        non_creator = users(:two)      
    end

    test "should get index" do
        sign_in_as @user
        get trips_url
        assert_response :success
    end

    test "should get new" do
        sign_in_as @user
        get new_trip_url
        assert_response :success
    end

    test "should create trip" do
        sign_in_as @user

        assert_difference("Trip.count") do
        post trips_url, params: { trip: {
            name: "Trip name",
            user_id: @user.id, 
        } }
        end

        assert_redirected_to trip_url(Trip.last)
    end

    test "should show trip" do
        sign_in_as @user
        get trip_url(@trip)
        assert_response :success
    end
  
    test "owner can add existing user to trip" do
        sign_in_as @user
        existing_user = User.create!(name: "Participant", email_address: "test@yahoo.com", password: "password") #Creem un user înainte de request.

        post add_participant_trip_url(@trip), params: { email_address: existing_user.email_address } #trebuie testat daca a fost adaugat un participant; Trimitem request-ul post care introduce un email existent si apasă „Add participant”

        assert @trip.users.include?(existing_user) #verificam că userul a fost adăugat la trip
    end

    test "owner can add non existing user to trip" do #vrem sa adaugam un user care nu exista in db
        sign_in_as @user
        name = "New Participant"   #avem un user nou, cu nume si email
        email_address = "new_participant@yahoo.com"

        assert_not User.exists?(email_address: email_address)   #trebuie sa verificam ca nu exista in DB

        post add_participant_trip_url(@trip), params: { email_address: email_address, name: name } #vrem sa il adaugam

        created_user = User.find_by(email_address: email_address)  #userul exista acum?

        assert @trip.users.include?(created_user)   #verificam ca userul a fost adaugat la trip
    end

    test "non creator cannot add participants to trip" do       
        sign_in_as non_creator
        post add_participant_trip_url(@trip)
        assert_redirected_to trip_url(@trip)
    end

end