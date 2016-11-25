require 'test_helper'

class InscripcionsControllerTest < ActionController::TestCase
  setup do
    @inscripcion = inscripcions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:inscripcions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create inscripcion" do
    assert_difference('Inscripcion.count') do
      post :create, inscripcion: { documentacion: @inscripcion.documentacion, escuela_titular: @inscripcion.escuela_titular, establecimiento_id: @inscripcion.establecimiento_id, establecimiento_id: @inscripcion.establecimiento_id, fecha_incripcion: @inscripcion.fecha_incripcion, funcion_id: @inscripcion.funcion_id, funcion_id: @inscripcion.funcion_id, lugar_serv_act: @inscripcion.lugar_serv_act, nivel_id: @inscripcion.nivel_id, nivel_id: @inscripcion.nivel_id, persona_id: @inscripcion.persona_id, pesona_id: @inscripcion.pesona_id, rubro_id: @inscripcion.rubro_id, rubro_id: @inscripcion.rubro_id, serv_activo: @inscripcion.serv_activo }
    end

    assert_redirected_to inscripcion_path(assigns(:inscripcion))
  end

  test "should show inscripcion" do
    get :show, id: @inscripcion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @inscripcion
    assert_response :success
  end

  test "should update inscripcion" do
    patch :update, id: @inscripcion, inscripcion: { documentacion: @inscripcion.documentacion, escuela_titular: @inscripcion.escuela_titular, establecimiento_id: @inscripcion.establecimiento_id, establecimiento_id: @inscripcion.establecimiento_id, fecha_incripcion: @inscripcion.fecha_incripcion, funcion_id: @inscripcion.funcion_id, funcion_id: @inscripcion.funcion_id, lugar_serv_act: @inscripcion.lugar_serv_act, nivel_id: @inscripcion.nivel_id, nivel_id: @inscripcion.nivel_id, persona_id: @inscripcion.persona_id, pesona_id: @inscripcion.pesona_id, rubro_id: @inscripcion.rubro_id, rubro_id: @inscripcion.rubro_id, serv_activo: @inscripcion.serv_activo }
    assert_redirected_to inscripcion_path(assigns(:inscripcion))
  end

  test "should destroy inscripcion" do
    assert_difference('Inscripcion.count', -1) do
      delete :destroy, id: @inscripcion
    end

    assert_redirected_to inscripcions_path
  end
end
