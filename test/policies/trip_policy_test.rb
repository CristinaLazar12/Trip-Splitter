require 'test_helper'

class TripPolicyTest < ActiveSupport::TestCase

  def test_add_participant
    creator = User.create!(name: "Ana", email_address: "ana@test.com", password: "password")
    trip = Trip.create!(name: "Paris", creator_id: creator.id)

    policy = TripPolicy.new(creator, trip)

    assert policy.add_participant?
  end

  def test_remove_participant
    creator = User.create!(name: "Ana", email_address: "ana1@test.com", password: "password")
    trip = Trip.create!(name: "Paris2026", creator_id: creator.id)

    policy = TripPolicy.new(creator, trip)

    assert policy.remove_participant?
  end

  def test_non_creator_cannot_add_participant
    creator = User.create!(name: "Ana", email_address: "ana2@test.com", password: "password")
    non_creator = User.create!(name: "Vali", email_address: "vali1@test.com", password: "password1")

    trip = Trip.create!(name: "Paris", creator_id: creator.id)

    policy = TripPolicy.new(non_creator, trip)

    assert_not policy.add_participant?
  end

  def test_non_creator_cannot_remove_participant
    creator = User.create!(name: "Ana", email_address: "ana3@test.com", password: "password")
    non_creator = User.create!(name: "Vali", email_address: "vali2@test.com", password: "password1")

    trip = Trip.create!(name: "Paris2024", creator_id: creator.id)

    policy = TripPolicy.new(non_creator, trip)

    assert_not policy.remove_participant?
  end
end
