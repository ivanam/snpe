require 'test_helper'

class CargosControllerTest < ActionController::TestCase
  setup do
    @cargo = cargos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargo" do
    assert_difference('Cargo.count') do
      post :create, cargo: { alta_lote_impresion_id: @cargo.alta_lote_impresion_id, anio: @cargo.anio, baja_lote_impresion: @cargo.baja_lote_impresion, cargo: @cargo.cargo, curso: @cargo.curso, establecimiento_id: @cargo.establecimiento_id, fecha_alta: @cargo.fecha_alta, fecha_baja: @cargo.fecha_baja, observatorio: @cargo.observatorio, persona_id: @cargo.persona_id, persona_reemplazada_id: @cargo.persona_reemplazada_id, secuencia: @cargo.secuencia, situacion_revista: @cargo.situacion_revista, turno: @cargo.turno }
    end

    assert_redirected_to cargo_path(assigns(:cargo))
  end

  test "should show cargo" do
    get :show, id: @cargo
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cargo
    assert_response :success
  end

  test "should update cargo" do
    patch :update, id: @cargo, cargo: { alta_lote_impresion_id: @cargo.alta_lote_impresion_id, anio: @cargo.anio, baja_lote_impresion: @cargo.baja_lote_impresion, cargo: @cargo.cargo, curso: @cargo.curso, establecimiento_id: @cargo.establecimiento_id, fecha_alta: @cargo.fecha_alta, fecha_baja: @cargo.fecha_baja, observatorio: @cargo.observatorio, persona_id: @cargo.persona_id, persona_reemplazada_id: @cargo.persona_reemplazada_id, secuencia: @cargo.secuencia, situacion_revista: @cargo.situacion_revista, turno: @cargo.turno }
    assert_redirected_to cargo_path(assigns(:cargo))
  end

  test "should destroy cargo" do
    assert_difference('Cargo.count', -1) do
      delete :destroy, id: @cargo
    end

    assert_redirected_to cargos_path
  end
end
