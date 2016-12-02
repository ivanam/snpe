require 'test_helper'

class AmbitosControllerTest < ActionController::TestCase
  setup do
    @ambito = ambitos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ambitos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ambito" do
    assert_difference('Ambito.count') do
      post :create, ambito: { inscripcion_id: @ambito.inscripcion_id, nombre: @ambito.nombre }
    end

    assert_redirected_to ambito_path(assigns(:ambito))
  end

  test "should show ambito" do
    get :show, id: @ambito
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ambito
    assert_response :success
  end

  test "should update ambito" do
    patch :update, id: @ambito, ambito: { inscripcion_id: @ambito.inscripcion_id, nombre: @ambito.nombre }
    assert_redirected_to ambito_path(assigns(:ambito))
  end

  test "should destroy ambito" do
    assert_difference('Ambito.count', -1) do
      delete :destroy, id: @ambito
    end

    assert_redirected_to ambitos_path
  end
end
