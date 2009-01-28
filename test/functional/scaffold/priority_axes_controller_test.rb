require 'test_helper'

class Scaffold::PriorityAxesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:priority_axes)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_priority_axis
    assert_difference('PriorityAxis.count') do
      post :create, :priority_axis => { }
    end

    assert_redirected_to priority_axis_path(assigns(:priority_axis))
  end

  def test_should_show_priority_axis
    get :show, :id => priority_axes(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => priority_axes(:one).id
    assert_response :success
  end

  def test_should_update_priority_axis
    put :update, :id => priority_axes(:one).id, :priority_axis => { }
    assert_redirected_to priority_axis_path(assigns(:priority_axis))
  end

  def test_should_destroy_priority_axis
    assert_difference('PriorityAxis.count', -1) do
      delete :destroy, :id => priority_axes(:one).id
    end

    assert_redirected_to priority_axes_path
  end
end
