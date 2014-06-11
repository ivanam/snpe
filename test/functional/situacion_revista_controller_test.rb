require 'test_helper'

class SituacionRevistaControllerTest < ActionController::TestCase
  setup do
    @situacion_revistum = situacion_revista(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:situacion_revista)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create situacion_revistum" do
    assert_difference('SituacionRevistum.count') do
      post :create, situacion_revistum: { nombre: @situacion_revistum.nombre }
    end

    assert_redirected_to situacion_revistum_path(assigns(:situacion_revistum))
  end

  test "should show situacion_revistum" do
    get :show, id: @situacion_revistum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @situacion_revistum
    assert_response :success
  end

  test "should update situacion_revistum" do
    put :update, id: @situacion_revistum, situacion_revistum: { nombre: @situacion_revistum.nombre }
    assert_redirected_to situacion_revistum_path(assigns(:situacion_revistum))
  end

  test "should destroy situacion_revistum" do
    assert_difference('SituacionRevistum.count', -1) do
      delete :destroy, id: @situacion_revistum
    end

    assert_redirected_to situacion_revista_path
  end
end
