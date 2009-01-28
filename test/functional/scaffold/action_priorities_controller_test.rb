require 'test_helper'

class Scaffold::ActionPrioritiesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:action_priorities)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_action_priority
    assert_difference('ActionPriority.count') do
      post :create, :action_priority => { }
    end

    assert_redirected_to action_priority_path(assigns(:action_priority))
  end

  def test_should_show_action_priority
    get :show, :id => action_priorities(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => action_priorities(:one).id
    assert_response :success
  end

  def test_should_update_action_priority
    put :update, :id => action_priorities(:one).id, :action_priority => { }
    assert_redirected_to action_priority_path(assigns(:action_priority))
  end

  def test_should_destroy_action_priority
    assert_difference('ActionPriority.count', -1) do
      delete :destroy, :id => action_priorities(:one).id
    end

    assert_redirected_to action_priorities_path
  end
end
