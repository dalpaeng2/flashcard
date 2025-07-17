require "test_helper"

class DecksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get decks_url
    assert_response :success
  end
end
