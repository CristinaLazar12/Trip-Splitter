require "test_helper"

class UserTest < ActiveSupport::TestCase

    test "invalid without name" do
      user = User.create(email_address: "email@test.com", password: "password")

      assert user.invalid?
      assert_includes user.errors[:name], "can't be blank"
    end

    test "invalid without email_address" do
      user = User.create(name: "User", password: "password")

      assert user.invalid?
      assert_includes user.errors[:email_address], "can't be blank"
    end

    test "invalid without password" do
      user = User.create(name: "User", email_address: "email@test.com")

      assert user.invalid?
      assert_includes user.errors[:password], "can't be blank"
    end

    test "valid with a name, email_address, password" do
      user = User.create(name: "User", email_address: "email@test.com", password: "password")

      assert user.valid?
    end

    test "can be a creator" do
      user = User.create(name: "Trip creator", email_address: "email@test.com", password: "password")
      trip = Trip.create(name: "Trip", creator: user)

      assert_equal user, trip.creator
    end

    test "can be a participant" do
      creator = User.create(name: "Creator", email_address: "creatoremail@test.com", password: "password")
      participant = User.create(name: "Participant", email_address: "email@test.com", password: "password")
      trip = Trip.create(name: "Creator", creator: creator)

      trip.users << participant
      assert_includes trip.users, participant
    end

    test "cand have expenses" do
      creator = users(:one)
      trip = trips(:one)
      user = User.create(name: "Participant", email_address: "email@test.com", password: "password")
      expense = Expense.new(
            title: "Dinner",
            amount: 80,
            currency: "RON",
            date: Date.new(2025, 10, 10),
            split_type: "equal",
            trip: trip,
            payer: creator
        )
        
        expense.users << user

        assert_includes expense.users, user
    end
end
