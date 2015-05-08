require 'test_helper'

class AltasBajasHorasControllerTest < ActionController::TestCase
  setup do
    @altas_bajas_hora = altas_bajas_horas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:altas_bajas_horas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create altas_bajas_hora" do
    assert_difference('AltasBajasHora.count') do
      post :create, altas_bajas_hora: { anio: @altas_bajas_hora.anio, anio_periodo: @altas_bajas_hora.anio_periodo, ciclo_carrera: @altas_bajas_hora.ciclo_carrera, codificacion: @altas_bajas_hora.codificacion, division: @altas_bajas_hora.division, establecimiento_id: @altas_bajas_hora.establecimiento_id, fecha_alta: @altas_bajas_hora.fecha_alta, fecha_baja: @altas_bajas_hora.fecha_baja, horas: @altas_bajas_hora.horas, mes_periodo: @altas_bajas_hora.mes_periodo, oblig: @altas_bajas_hora.oblig, observaciones: @altas_bajas_hora.observaciones, persona_id: @altas_bajas_hora.persona_id, secuencia: @altas_bajas_hora.secuencia, situacion_revista: @altas_bajas_hora.situacion_revista, turno: @altas_bajas_hora.turno }
    end

    assert_redirected_to altas_bajas_hora_path(assigns(:altas_bajas_hora))
  end

  test "should show altas_bajas_hora" do
    get :show, id: @altas_bajas_hora
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @altas_bajas_hora
    assert_response :success
  end

  test "should update altas_bajas_hora" do
    patch :update, id: @altas_bajas_hora, altas_bajas_hora: { anio: @altas_bajas_hora.anio, anio_periodo: @altas_bajas_hora.anio_periodo, ciclo_carrera: @altas_bajas_hora.ciclo_carrera, codificacion: @altas_bajas_hora.codificacion, division: @altas_bajas_hora.division, establecimiento_id: @altas_bajas_hora.establecimiento_id, fecha_alta: @altas_bajas_hora.fecha_alta, fecha_baja: @altas_bajas_hora.fecha_baja, horas: @altas_bajas_hora.horas, mes_periodo: @altas_bajas_hora.mes_periodo, oblig: @altas_bajas_hora.oblig, observaciones: @altas_bajas_hora.observaciones, persona_id: @altas_bajas_hora.persona_id, secuencia: @altas_bajas_hora.secuencia, situacion_revista: @altas_bajas_hora.situacion_revista, turno: @altas_bajas_hora.turno }
    assert_redirected_to altas_bajas_hora_path(assigns(:altas_bajas_hora))
  end

  test "should destroy altas_bajas_hora" do
    assert_difference('AltasBajasHora.count', -1) do
      delete :destroy, id: @altas_bajas_hora
    end

    assert_redirected_to altas_bajas_horas_path
  end
end
