require 'test_helper'

class CargoNoDocentesControllerTest < ActionController::TestCase
  setup do
    @cargo_no_docente = cargo_no_docentes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargo_no_docentes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargo_no_docente" do
    assert_difference('CargoNoDocente.count') do
      post :create, cargo_no_docente: { alta_lote_impresion_id_id: @cargo_no_docente.alta_lote_impresion_id_id, baja_lote_impresion_id: @cargo_no_docente.baja_lote_impresion_id, cantidad_dias_licencia: @cargo_no_docente.cantidad_dias_licencia, cargo: @cargo_no_docente.cargo, con_movilidad: @cargo_no_docente.con_movilidad, empresa_id: @cargo_no_docente.empresa_id, establecimiento_id: @cargo_no_docente.establecimiento_id, fecha_alta: @cargo_no_docente.fecha_alta, fecha_baja: @cargo_no_docente.fecha_baja, ina_injustificadas: @cargo_no_docente.ina_injustificadas, licencia_desde: @cargo_no_docente.licencia_desde, licencia_hasta: @cargo_no_docente.licencia_hasta, lugar_pago_id: @cargo_no_docente.lugar_pago_id, motivo_baja: @cargo_no_docente.motivo_baja, observatorio: @cargo_no_docente.observatorio, persona_id: @cargo_no_docente.persona_id, persona_reemplazada_id: @cargo_no_docente.persona_reemplazada_id, secuencia: @cargo_no_docente.secuencia, turno: @cargo_no_docente.turno }
    end

    assert_redirected_to cargo_no_docente_path(assigns(:cargo_no_docente))
  end

  test "should show cargo_no_docente" do
    get :show, id: @cargo_no_docente
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cargo_no_docente
    assert_response :success
  end

  test "should update cargo_no_docente" do
    patch :update, id: @cargo_no_docente, cargo_no_docente: { alta_lote_impresion_id_id: @cargo_no_docente.alta_lote_impresion_id_id, baja_lote_impresion_id: @cargo_no_docente.baja_lote_impresion_id, cantidad_dias_licencia: @cargo_no_docente.cantidad_dias_licencia, cargo: @cargo_no_docente.cargo, con_movilidad: @cargo_no_docente.con_movilidad, empresa_id: @cargo_no_docente.empresa_id, establecimiento_id: @cargo_no_docente.establecimiento_id, fecha_alta: @cargo_no_docente.fecha_alta, fecha_baja: @cargo_no_docente.fecha_baja, ina_injustificadas: @cargo_no_docente.ina_injustificadas, licencia_desde: @cargo_no_docente.licencia_desde, licencia_hasta: @cargo_no_docente.licencia_hasta, lugar_pago_id: @cargo_no_docente.lugar_pago_id, motivo_baja: @cargo_no_docente.motivo_baja, observatorio: @cargo_no_docente.observatorio, persona_id: @cargo_no_docente.persona_id, persona_reemplazada_id: @cargo_no_docente.persona_reemplazada_id, secuencia: @cargo_no_docente.secuencia, turno: @cargo_no_docente.turno }
    assert_redirected_to cargo_no_docente_path(assigns(:cargo_no_docente))
  end

  test "should destroy cargo_no_docente" do
    assert_difference('CargoNoDocente.count', -1) do
      delete :destroy, id: @cargo_no_docente
    end

    assert_redirected_to cargo_no_docentes_path
  end
end
