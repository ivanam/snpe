require 'test_helper'

class LoteImpresionsControllerTest < ActionController::TestCase
  setup do
    @lote_impresion = lote_impresions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lote_impresions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lote_impresion" do
    assert_difference('LoteImpresion.count') do
      post :create, lote_impresion: { fecha_impresion: @lote_impresion.fecha_impresion, observaciones: @lote_impresion.observaciones }
    end

    assert_redirected_to lote_impresion_path(assigns(:lote_impresion))
  end

  test "should show lote_impresion" do
    get :show, id: @lote_impresion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lote_impresion
    assert_response :success
  end

  test "should update lote_impresion" do
    patch :update, id: @lote_impresion, lote_impresion: { fecha_impresion: @lote_impresion.fecha_impresion, observaciones: @lote_impresion.observaciones }
    assert_redirected_to lote_impresion_path(assigns(:lote_impresion))
  end

  test "should destroy lote_impresion" do
    assert_difference('LoteImpresion.count', -1) do
      delete :destroy, id: @lote_impresion
    end

    assert_redirected_to lote_impresions_path
  end
end
