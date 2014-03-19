require 'test_helper'

class ResControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
