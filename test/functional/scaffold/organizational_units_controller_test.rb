require 'test_helper'

class Scaffold::OrganizationalUnitsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:organizational_units)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_organizational_unit
    assert_difference('OrganizationalUnit.count') do
      post :create, :organizational_unit => { }
    end

    assert_redirected_to organizational_unit_path(assigns(:organizational_unit))
  end

  def test_should_show_organizational_unit
    get :show, :id => organizational_units(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => organizational_units(:one).id
    assert_response :success
  end

  def test_should_update_organizational_unit
    put :update, :id => organizational_units(:one).id, :organizational_unit => { }
    assert_redirected_to organizational_unit_path(assigns(:organizational_unit))
  end

  def test_should_destroy_organizational_unit
    assert_difference('OrganizationalUnit.count', -1) do
      delete :destroy, :id => organizational_units(:one).id
    end

    assert_redirected_to organizational_units_path
  end
end
