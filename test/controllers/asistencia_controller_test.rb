require 'test_helper'

class AsistenciaControllerTest < ActionController::TestCase
  setup do
    @asistencium = asistencia(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asistencia)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asistencium" do
    assert_difference('Asistencium.count') do
      post :create, asistencium: { altas_bajas_cargo_id: @asistencium.altas_bajas_cargo_id, altas_bajas_hora_id: @asistencium.altas_bajas_hora_id, ina_injustificada: @asistencium.ina_injustificada, ina_justificada: @asistencium.ina_justificada, ina_total: @asistencium.ina_total, lleg_tarde_injustificada: @asistencium.lleg_tarde_injustificada, lleg_tarde_justificada: @asistencium.lleg_tarde_justificada, lleg_tarde_total: @asistencium.lleg_tarde_total }
    end

    assert_redirected_to asistencium_path(assigns(:asistencium))
  end

  test "should show asistencium" do
    get :show, id: @asistencium
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @asistencium
    assert_response :success
  end

  test "should update asistencium" do
    patch :update, id: @asistencium, asistencium: { altas_bajas_cargo_id: @asistencium.altas_bajas_cargo_id, altas_bajas_hora_id: @asistencium.altas_bajas_hora_id, ina_injustificada: @asistencium.ina_injustificada, ina_justificada: @asistencium.ina_justificada, ina_total: @asistencium.ina_total, lleg_tarde_injustificada: @asistencium.lleg_tarde_injustificada, lleg_tarde_justificada: @asistencium.lleg_tarde_justificada, lleg_tarde_total: @asistencium.lleg_tarde_total }
    assert_redirected_to asistencium_path(assigns(:asistencium))
  end

  test "should destroy asistencium" do
    assert_difference('Asistencium.count', -1) do
      delete :destroy, id: @asistencium
    end

    assert_redirected_to asistencia_path
  end
end
