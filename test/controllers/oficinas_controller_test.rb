require 'test_helper'

class OficinasControllerTest < ActionController::TestCase
  setup do
    @oficina = oficinas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:oficinas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create oficina" do
    assert_difference('Oficina.count') do
      post :create, oficina: { nombre: @oficina.nombre, tipo: @oficina.tipo }
    end

    assert_redirected_to oficina_path(assigns(:oficina))
  end

  test "should show oficina" do
    get :show, id: @oficina
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @oficina
    assert_response :success
  end

  test "should update oficina" do
    patch :update, id: @oficina, oficina: { nombre: @oficina.nombre, tipo: @oficina.tipo }
    assert_redirected_to oficina_path(assigns(:oficina))
  end

  test "should destroy oficina" do
    assert_difference('Oficina.count', -1) do
      delete :destroy, id: @oficina
    end

    assert_redirected_to oficinas_path
  end
end
