require 'test_helper'

class JuntafuncionsControllerTest < ActionController::TestCase
  setup do
    @juntafuncion = juntafuncions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:juntafuncions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create juntafuncion" do
    assert_difference('Juntafuncion.count') do
      post :create, juntafuncion: { descripcion: @juntafuncion.descripcion }
    end

    assert_redirected_to juntafuncion_path(assigns(:juntafuncion))
  end

  test "should show juntafuncion" do
    get :show, id: @juntafuncion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @juntafuncion
    assert_response :success
  end

  test "should update juntafuncion" do
    patch :update, id: @juntafuncion, juntafuncion: { descripcion: @juntafuncion.descripcion }
    assert_redirected_to juntafuncion_path(assigns(:juntafuncion))
  end

  test "should destroy juntafuncion" do
    assert_difference('Juntafuncion.count', -1) do
      delete :destroy, id: @juntafuncion
    end

    assert_redirected_to juntafuncions_path
  end
end
