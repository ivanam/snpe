require 'test_helper'

class CargosEspecialsControllerTest < ActionController::TestCase
  setup do
    @cargos_especial = cargos_especials(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargos_especials)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargos_especial" do
    assert_difference('CargosEspecial.count') do
      post :create, cargos_especial: { descripcion: @cargos_especial.descripcion }
    end

    assert_redirected_to cargos_especial_path(assigns(:cargos_especial))
  end

  test "should show cargos_especial" do
    get :show, id: @cargos_especial
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cargos_especial
    assert_response :success
  end

  test "should update cargos_especial" do
    patch :update, id: @cargos_especial, cargos_especial: { descripcion: @cargos_especial.descripcion }
    assert_redirected_to cargos_especial_path(assigns(:cargos_especial))
  end

  test "should destroy cargos_especial" do
    assert_difference('CargosEspecial.count', -1) do
      delete :destroy, id: @cargos_especial
    end

    assert_redirected_to cargos_especials_path
  end
end
