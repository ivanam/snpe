require 'test_helper'

class PrimariaCargosControllerTest < ActionController::TestCase
  setup do
    @primaria_cargo = primaria_cargos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:primaria_cargos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create primaria_cargo" do
    assert_difference('PrimariaCargo.count') do
      post :create, primaria_cargo: { cargo_inscrip_doc_id: @primaria_cargo.cargo_inscrip_doc_id, codigo_nomen: @primaria_cargo.codigo_nomen, descripcion: @primaria_cargo.descripcion, funcion_id: @primaria_cargo.funcion_id, inscripcion_id: @primaria_cargo.inscripcion_id }
    end

    assert_redirected_to primaria_cargo_path(assigns(:primaria_cargo))
  end

  test "should show primaria_cargo" do
    get :show, id: @primaria_cargo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @primaria_cargo
    assert_response :success
  end

  test "should update primaria_cargo" do
    patch :update, id: @primaria_cargo, primaria_cargo: { cargo_inscrip_doc_id: @primaria_cargo.cargo_inscrip_doc_id, codigo_nomen: @primaria_cargo.codigo_nomen, descripcion: @primaria_cargo.descripcion, funcion_id: @primaria_cargo.funcion_id, inscripcion_id: @primaria_cargo.inscripcion_id }
    assert_redirected_to primaria_cargo_path(assigns(:primaria_cargo))
  end

  test "should destroy primaria_cargo" do
    assert_difference('PrimariaCargo.count', -1) do
      delete :destroy, id: @primaria_cargo
    end

    assert_redirected_to primaria_cargos_path
  end
end
