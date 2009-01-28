require 'test_helper'

class Scaffold::ActionStatusesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:action_statuses)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_action_status
    assert_difference('ActionStatus.count') do
      post :create, :action_status => { }
    end

    assert_redirected_to action_status_path(assigns(:action_status))
  end

  def test_should_show_action_status
    get :show, :id => action_statuses(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => action_statuses(:one).id
    assert_response :success
  end

  def test_should_update_action_status
    put :update, :id => action_statuses(:one).id, :action_status => { }
    assert_redirected_to action_status_path(assigns(:action_status))
  end

  def test_should_destroy_action_status
    assert_difference('ActionStatus.count', -1) do
      delete :destroy, :id => action_statuses(:one).id
    end

    assert_redirected_to action_statuses_path
  end
end
