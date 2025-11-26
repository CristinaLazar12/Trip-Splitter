require "test_helper"

class TripTest < ActiveSupport::TestCase
  test "invalid without a name" do
    trip = Trip.new
    assert_not trip.valid?
    assert_includes trip.errors[:name], "can't be blank"
  end

  test "invalid without a user" do
    trip = Trip.new
    assert_not trip.valid?
    assert_includes trip.errors[:user], "can't be blank"
  end

  test "create a trip" do
    current_user = User.create(name: "Test User",
                              email: "test@example.com",
                              email_address: "test@example.com", 
                              password: "password")
    trip = Trip.new(user: current_user, name: "Test trip")
    assert trip.valid?
  end
end