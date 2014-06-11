require 'test_helper'

class EstablecimientosControllerTest < ActionController::TestCase
  setup do
    @establecimiento = establecimientos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:establecimientos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create establecimiento" do
    assert_difference('Establecimiento.count') do
      post :create, establecimiento: { ambito: @establecimiento.ambito, anexo: @establecimiento.anexo, codigo_jurisdiccional: @establecimiento.codigo_jurisdiccional, cue: @establecimiento.cue, cue_anexo: @establecimiento.cue_anexo, domicilio: @establecimiento.domicilio, localidad_id: @establecimiento.localidad_id, nombre: @establecimiento.nombre, sector: @establecimiento.sector }
    end

    assert_redirected_to establecimiento_path(assigns(:establecimiento))
  end

  test "should show establecimiento" do
    get :show, id: @establecimiento
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @establecimiento
    assert_response :success
  end

  test "should update establecimiento" do
    put :update, id: @establecimiento, establecimiento: { ambito: @establecimiento.ambito, anexo: @establecimiento.anexo, codigo_jurisdiccional: @establecimiento.codigo_jurisdiccional, cue: @establecimiento.cue, cue_anexo: @establecimiento.cue_anexo, domicilio: @establecimiento.domicilio, localidad_id: @establecimiento.localidad_id, nombre: @establecimiento.nombre, sector: @establecimiento.sector }
    assert_redirected_to establecimiento_path(assigns(:establecimiento))
  end

  test "should destroy establecimiento" do
    assert_difference('Establecimiento.count', -1) do
      delete :destroy, id: @establecimiento
    end

    assert_redirected_to establecimientos_path
  end
end
