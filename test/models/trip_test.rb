require "test_helper"

class TripTest < ActiveSupport::TestCase
  test "invalid without a name" do
    trip = Trip.new #tripul e invalid fara un nume, deci nu trecem aici nume
    assert trip.invalid? #tripul este invalid
    assert_includes trip.errors[:name], "can't be blank"
  end

  test "invalid without a creator" do
    trip = Trip.new(name: "First Trip") #tripul e invalid fara creator, asa ca ii adaugam nume si nu si creator
    assert trip.invalid? #tripul este invalid
    assert_includes trip.errors[:creator], "must exist"
  end

  test "valid with a name and creator" do
    creator = User.create(email_address: "test@test.com", password: "password")
    trip = Trip.new(name: "Test trip", creator: creator)

    assert trip.valid?
  end

  test "can have participants" do
    creator = User.create(name: "User1", email_address: "test@test.com", password: "password")
    trip = Trip.new(name: "Test trip", creator: creator)

    participant1 = User.create(name: "User2", email_address: "test1@test.com", password: "password1")
    participant2 = User.create(name: "User3", email_address: "test2@test.com", password: "password2")

    trip.users << participant1
    trip.users << participant2

    assert trip.valid?
    assert_includes trip.users, participant1
    assert_includes trip.users, participant2
  end
end