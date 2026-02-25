require 'test_helper'

class TripRoutesTest < ActionDispatch::IntegrationTest
  test "trip route test" do
    assert_routing '/trip', controller: "trips", action: "index"
  end
end