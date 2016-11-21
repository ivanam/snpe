require 'test_helper'

class CargosndsControllerTest < ActionController::TestCase
  setup do
    @cargosnd = cargosnds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargosnds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargosnd" do
    assert_difference('Cargosnd.count') do
      post :create, cargosnd: { cargo_agrup: @cargosnd.cargo_agrup, cargo_categ: @cargosnd.cargo_categ, cargo_cod: @cargosnd.cargo_cod, cargo_desc: @cargosnd.cargo_desc, nivel: @cargosnd.nivel }
    end

    assert_redirected_to cargosnd_path(assigns(:cargosnd))
  end

  test "should show cargosnd" do
    get :show, id: @cargosnd
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cargosnd
    assert_response :success
  end

  test "should update cargosnd" do
    patch :update, id: @cargosnd, cargosnd: { cargo_agrup: @cargosnd.cargo_agrup, cargo_categ: @cargosnd.cargo_categ, cargo_cod: @cargosnd.cargo_cod, cargo_desc: @cargosnd.cargo_desc, nivel: @cargosnd.nivel }
    assert_redirected_to cargosnd_path(assigns(:cargosnd))
  end

  test "should destroy cargosnd" do
    assert_difference('Cargosnd.count', -1) do
      delete :destroy, id: @cargosnd
    end

    assert_redirected_to cargosnds_path
  end
end
