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
      post :create, establecimiento: { alta: @establecimiento.alta, ambito: @establecimiento.ambito, anexo: @establecimiento.anexo, baja: @establecimiento.baja, codigo_jurisdiccional: @establecimiento.codigo_jurisdiccional, cue: @establecimiento.cue, cue_anexo: @establecimiento.cue_anexo, cuise: @establecimiento.cuise, dependencia: @establecimiento.dependencia, domicilio: @establecimiento.domicilio, email: @establecimiento.email, ift: @establecimiento.ift, isotipo: @establecimiento.isotipo, localidad_id: @establecimiento.localidad_id, nivel_id: @establecimiento.nivel_id, nombre: @establecimiento.nombre, numero: @establecimiento.numero, organizacion_id: @establecimiento.organizacion_id, privada: @establecimiento.privada, responsable: @establecimiento.responsable, rght: @establecimiento.rght, sector: @establecimiento.sector, sistema: @establecimiento.sistema, tipo: @establecimiento.tipo, zona: @establecimiento.zona }
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
    patch :update, id: @establecimiento, establecimiento: { alta: @establecimiento.alta, ambito: @establecimiento.ambito, anexo: @establecimiento.anexo, baja: @establecimiento.baja, codigo_jurisdiccional: @establecimiento.codigo_jurisdiccional, cue: @establecimiento.cue, cue_anexo: @establecimiento.cue_anexo, cuise: @establecimiento.cuise, dependencia: @establecimiento.dependencia, domicilio: @establecimiento.domicilio, email: @establecimiento.email, ift: @establecimiento.ift, isotipo: @establecimiento.isotipo, localidad_id: @establecimiento.localidad_id, nivel_id: @establecimiento.nivel_id, nombre: @establecimiento.nombre, numero: @establecimiento.numero, organizacion_id: @establecimiento.organizacion_id, privada: @establecimiento.privada, responsable: @establecimiento.responsable, rght: @establecimiento.rght, sector: @establecimiento.sector, sistema: @establecimiento.sistema, tipo: @establecimiento.tipo, zona: @establecimiento.zona }
    assert_redirected_to establecimiento_path(assigns(:establecimiento))
  end

  test "should destroy establecimiento" do
    assert_difference('Establecimiento.count', -1) do
      delete :destroy, id: @establecimiento
    end

    assert_redirected_to establecimientos_path
  end
end
