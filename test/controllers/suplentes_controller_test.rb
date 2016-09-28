require 'test_helper'

class SuplentesControllerTest < ActionController::TestCase
  setup do
    @suplente = suplentes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:suplentes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create suplente" do
    assert_difference('Suplente.count') do
      post :create, suplente: { altas_bajas_hora_id: @suplente.altas_bajas_hora_id, altas_bajas_hora_suplantada_id: @suplente.altas_bajas_hora_suplantada_id, estado: @suplente.estado, fecha_desde: @suplente.fecha_desde, fecha_hasta: @suplente.fecha_hasta, observaciones: @suplente.observaciones }
    end

    assert_redirected_to suplente_path(assigns(:suplente))
  end

  test "should show suplente" do
    get :show, id: @suplente
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @suplente
    assert_response :success
  end

  test "should update suplente" do
    patch :update, id: @suplente, suplente: { altas_bajas_hora_id: @suplente.altas_bajas_hora_id, altas_bajas_hora_suplantada_id: @suplente.altas_bajas_hora_suplantada_id, estado: @suplente.estado, fecha_desde: @suplente.fecha_desde, fecha_hasta: @suplente.fecha_hasta, observaciones: @suplente.observaciones }
    assert_redirected_to suplente_path(assigns(:suplente))
  end

  test "should destroy suplente" do
    assert_difference('Suplente.count', -1) do
      delete :destroy, id: @suplente
    end

    assert_redirected_to suplentes_path
  end
end
