require 'test_helper'

class Scaffold::PriorityRangesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:priority_ranges)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_priority_range
    assert_difference('PriorityRange.count') do
      post :create, :priority_range => { }
    end

    assert_redirected_to priority_range_path(assigns(:priority_range))
  end

  def test_should_show_priority_range
    get :show, :id => priority_ranges(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => priority_ranges(:one).id
    assert_response :success
  end

  def test_should_update_priority_range
    put :update, :id => priority_ranges(:one).id, :priority_range => { }
    assert_redirected_to priority_range_path(assigns(:priority_range))
  end

  def test_should_destroy_priority_range
    assert_difference('PriorityRange.count', -1) do
      delete :destroy, :id => priority_ranges(:one).id
    end

    assert_redirected_to priority_ranges_path
  end
end
