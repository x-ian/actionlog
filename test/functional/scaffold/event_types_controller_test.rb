require 'test_helper'

class Scaffold::EventTypesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:event_types)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_event_type
    assert_difference('EventType.count') do
      post :create, :event_type => { }
    end

    assert_redirected_to event_type_path(assigns(:event_type))
  end

  def test_should_show_event_type
    get :show, :id => event_types(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => event_types(:one).id
    assert_response :success
  end

  def test_should_update_event_type
    put :update, :id => event_types(:one).id, :event_type => { }
    assert_redirected_to event_type_path(assigns(:event_type))
  end

  def test_should_destroy_event_type
    assert_difference('EventType.count', -1) do
      delete :destroy, :id => event_types(:one).id
    end

    assert_redirected_to event_types_path
  end
end
