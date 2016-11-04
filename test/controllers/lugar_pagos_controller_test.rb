require 'test_helper'

class LugarPagosControllerTest < ActionController::TestCase
  setup do
    @lugar_pago = lugar_pagos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lugar_pagos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lugar_pago" do
    assert_difference('LugarPago.count') do
      post :create, lugar_pago: { codigo: @lugar_pago.codigo, descripcion: @lugar_pago.descripcion }
    end

    assert_redirected_to lugar_pago_path(assigns(:lugar_pago))
  end

  test "should show lugar_pago" do
    get :show, id: @lugar_pago
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lugar_pago
    assert_response :success
  end

  test "should update lugar_pago" do
    patch :update, id: @lugar_pago, lugar_pago: { codigo: @lugar_pago.codigo, descripcion: @lugar_pago.descripcion }
    assert_redirected_to lugar_pago_path(assigns(:lugar_pago))
  end

  test "should destroy lugar_pago" do
    assert_difference('LugarPago.count', -1) do
      delete :destroy, id: @lugar_pago
    end

    assert_redirected_to lugar_pagos_path
  end
end
