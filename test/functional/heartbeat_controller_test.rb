require 'test_helper'

class HeartbeatControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_select "p", "Everything up and running"
  end
end
