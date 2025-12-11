require "test_helper"

class TripsControllerTest < ActionDispatch::IntegrationTest

    setup do
        @trip  = trips(:one)
        @user  = users(:one)      
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
  
    test "owner should add participant to trip" do
        sign_in_as @user
        post add_participant_trip_url(@trip)
        assert_redirected_to trip_url(@trip)

    end

    test "non creator cannot add participants to trip" do
        sign_in_as @user
    end

end
