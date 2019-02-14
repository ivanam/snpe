require 'test_helper'

class MotivoBajasControllerTest < ActionController::TestCase
  setup do
    @motivo_baja = motivo_bajas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:motivo_bajas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create motivo_baja" do
    assert_difference('MotivoBaja.count') do
      post :create, motivo_baja: { motivo: @motivo_baja.motivo, nro_motivo: @motivo_baja.nro_motivo }
    end

    assert_redirected_to motivo_baja_path(assigns(:motivo_baja))
  end

  test "should show motivo_baja" do
    get :show, id: @motivo_baja
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @motivo_baja
    assert_response :success
  end

  test "should update motivo_baja" do
    patch :update, id: @motivo_baja, motivo_baja: { motivo: @motivo_baja.motivo, nro_motivo: @motivo_baja.nro_motivo }
    assert_redirected_to motivo_baja_path(assigns(:motivo_baja))
  end

  test "should destroy motivo_baja" do
    assert_difference('MotivoBaja.count', -1) do
      delete :destroy, id: @motivo_baja
    end

    assert_redirected_to motivo_bajas_path
  end
end
