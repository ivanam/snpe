require 'test_helper'

class TrasladosControllerTest < ActionController::TestCase
  setup do
    @traslado = traslados(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:traslados)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create traslado" do
    assert_difference('Traslado.count') do
      post :create, traslado: { alta_baja_hora_id: @traslado.alta_baja_hora_id, cargo_id: @traslado.cargo_id, cargo_no_docente_id: @traslado.cargo_no_docente_id, fecha_cambio_oficina: @traslado.fecha_cambio_oficina, user_id: @traslado.user_id }
    end

    assert_redirected_to traslado_path(assigns(:traslado))
  end

  test "should show traslado" do
    get :show, id: @traslado
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @traslado
    assert_response :success
  end

  test "should update traslado" do
    patch :update, id: @traslado, traslado: { alta_baja_hora_id: @traslado.alta_baja_hora_id, cargo_id: @traslado.cargo_id, cargo_no_docente_id: @traslado.cargo_no_docente_id, fecha_cambio_oficina: @traslado.fecha_cambio_oficina, user_id: @traslado.user_id }
    assert_redirected_to traslado_path(assigns(:traslado))
  end

  test "should destroy traslado" do
    assert_difference('Traslado.count', -1) do
      delete :destroy, id: @traslado
    end

    assert_redirected_to traslados_path
  end
end
