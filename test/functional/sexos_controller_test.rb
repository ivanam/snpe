require 'test_helper'

class SexosControllerTest < ActionController::TestCase
  setup do
    @sexo = sexos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sexos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sexo" do
    assert_difference('Sexo.count') do
      post :create, sexo: { nombre: @sexo.nombre }
    end

    assert_redirected_to sexo_path(assigns(:sexo))
  end

  test "should show sexo" do
    get :show, id: @sexo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sexo
    assert_response :success
  end

  test "should update sexo" do
    put :update, id: @sexo, sexo: { nombre: @sexo.nombre }
    assert_redirected_to sexo_path(assigns(:sexo))
  end

  test "should destroy sexo" do
    assert_difference('Sexo.count', -1) do
      delete :destroy, id: @sexo
    end

    assert_redirected_to sexos_path
  end
end
