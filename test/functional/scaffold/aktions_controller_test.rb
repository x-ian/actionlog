require 'test_helper'

class Scaffold::AktionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:aktions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def no_test_should_create_aktion
    assert_difference('Aktion.count') do
      post :create, :aktion => { }
    end

    assert_redirected_to aktion_path(assigns(:aktion))
  end

  def test_should_show_aktion
    get :show, :id => aktions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => aktions(:one).id
    assert_response :success
  end

  def no_test_should_update_aktion
    put :update, :id => aktions(:one).id, :aktion => { }
    assert_redirected_to aktion_path(assigns(:aktion))
  end

  def test_should_destroy_aktion
    assert_difference('Aktion.count', -1) do
      delete :destroy, :id => aktions(:one).id
    end

    assert_redirected_to aktions_path
  end
end
