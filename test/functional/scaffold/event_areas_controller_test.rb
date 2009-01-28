require 'test_helper'

class Scaffold::EventAreasControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:event_areas)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_event_area
    assert_difference('EventArea.count') do
      post :create, :event_area => { }
    end

    assert_redirected_to event_area_path(assigns(:event_area))
  end

  def test_should_show_event_area
    get :show, :id => event_areas(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => event_areas(:one).id
    assert_response :success
  end

  def test_should_update_event_area
    put :update, :id => event_areas(:one).id, :event_area => { }
    assert_redirected_to event_area_path(assigns(:event_area))
  end

  def test_should_destroy_event_area
    assert_difference('EventArea.count', -1) do
      delete :destroy, :id => event_areas(:one).id
    end

    assert_redirected_to event_areas_path
  end
end
