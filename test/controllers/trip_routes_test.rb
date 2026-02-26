require 'test_helper'

class TripRoutesTest < ActionDispatch::IntegrationTest
  test "trips route test" do
    assert_routing '/trips', controller: "trips", action: "index"
  end
end