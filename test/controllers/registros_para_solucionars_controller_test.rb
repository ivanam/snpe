require 'test_helper'

class RegistrosParaSolucionarsControllerTest < ActionController::TestCase
  setup do
    @registros_para_solucionar = registros_para_solucionars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registros_para_solucionars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registros_para_solucionar" do
    assert_difference('RegistrosParaSolucionar.count') do
      post :create, registros_para_solucionar: { anio: @registros_para_solucionar.anio, auxiliar_registro: @registros_para_solucionar.auxiliar_registro, cargo: @registros_para_solucionar.cargo, cargos_registro: @registros_para_solucionar.cargos_registro, ciclo_carrera: @registros_para_solucionar.ciclo_carrera, codificacion: @registros_para_solucionar.codificacion, division: @registros_para_solucionar.division, establecimiento_id: @registros_para_solucionar.establecimiento_id, estado: @registros_para_solucionar.estado, fecha_alta: @registros_para_solucionar.fecha_alta, fecha_baja: @registros_para_solucionar.fecha_baja, horas: @registros_para_solucionar.horas, horas_registro: @registros_para_solucionar.horas_registro, materium_id: @registros_para_solucionar.materium_id, persona_id: @registros_para_solucionar.persona_id, plan_id: @registros_para_solucionar.plan_id, secuencia: @registros_para_solucionar.secuencia, situacion_revista: @registros_para_solucionar.situacion_revista, turno: @registros_para_solucionar.turno }
    end

    assert_redirected_to registros_para_solucionar_path(assigns(:registros_para_solucionar))
  end

  test "should show registros_para_solucionar" do
    get :show, id: @registros_para_solucionar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registros_para_solucionar
    assert_response :success
  end

  test "should update registros_para_solucionar" do
    patch :update, id: @registros_para_solucionar, registros_para_solucionar: { anio: @registros_para_solucionar.anio, auxiliar_registro: @registros_para_solucionar.auxiliar_registro, cargo: @registros_para_solucionar.cargo, cargos_registro: @registros_para_solucionar.cargos_registro, ciclo_carrera: @registros_para_solucionar.ciclo_carrera, codificacion: @registros_para_solucionar.codificacion, division: @registros_para_solucionar.division, establecimiento_id: @registros_para_solucionar.establecimiento_id, estado: @registros_para_solucionar.estado, fecha_alta: @registros_para_solucionar.fecha_alta, fecha_baja: @registros_para_solucionar.fecha_baja, horas: @registros_para_solucionar.horas, horas_registro: @registros_para_solucionar.horas_registro, materium_id: @registros_para_solucionar.materium_id, persona_id: @registros_para_solucionar.persona_id, plan_id: @registros_para_solucionar.plan_id, secuencia: @registros_para_solucionar.secuencia, situacion_revista: @registros_para_solucionar.situacion_revista, turno: @registros_para_solucionar.turno }
    assert_redirected_to registros_para_solucionar_path(assigns(:registros_para_solucionar))
  end

  test "should destroy registros_para_solucionar" do
    assert_difference('RegistrosParaSolucionar.count', -1) do
      delete :destroy, id: @registros_para_solucionar
    end

    assert_redirected_to registros_para_solucionars_path
  end
end
