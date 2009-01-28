require 'test_helper'

class Scaffold::ActionVerbsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:action_verbs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_action_verb
    assert_difference('ActionVerb.count') do
      post :create, :action_verb => { }
    end

    assert_redirected_to action_verb_path(assigns(:action_verb))
  end

  def test_should_show_action_verb
    get :show, :id => action_verbs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => action_verbs(:one).id
    assert_response :success
  end

  def test_should_update_action_verb
    put :update, :id => action_verbs(:one).id, :action_verb => { }
    assert_redirected_to action_verb_path(assigns(:action_verb))
  end

  def test_should_destroy_action_verb
    assert_difference('ActionVerb.count', -1) do
      delete :destroy, :id => action_verbs(:one).id
    end

    assert_redirected_to action_verbs_path
  end
end
