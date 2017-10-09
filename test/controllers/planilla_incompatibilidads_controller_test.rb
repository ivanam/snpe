require 'test_helper'

class PlanillaIncompatibilidadsControllerTest < ActionController::TestCase
  setup do
    @planilla_incompatibilidad = planilla_incompatibilidads(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:planilla_incompatibilidads)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create planilla_incompatibilidad" do
    assert_difference('PlanillaIncompatibilidad.count') do
      post :create, planilla_incompatibilidad: { apellido: @planilla_incompatibilidad.apellido, dni: @planilla_incompatibilidad.dni, escuela_a: @planilla_incompatibilidad.escuela_a, escuela_b: @planilla_incompatibilidad.escuela_b, escuela_c: @planilla_incompatibilidad.escuela_c, escuela_d: @planilla_incompatibilidad.escuela_d, escuela_e: @planilla_incompatibilidad.escuela_e, fecha1: @planilla_incompatibilidad.fecha1, fecha2: @planilla_incompatibilidad.fecha2, fecha_nacimiento: @planilla_incompatibilidad.fecha_nacimiento, nombre: @planilla_incompatibilidad.nombre, nota_ingreso: @planilla_incompatibilidad.nota_ingreso, numero: @planilla_incompatibilidad.numero, observaciones_inc: @planilla_incompatibilidad.observaciones_inc, observaciones_suel: @planilla_incompatibilidad.observaciones_suel, text: @planilla_incompatibilidad.text }
    end

    assert_redirected_to planilla_incompatibilidad_path(assigns(:planilla_incompatibilidad))
  end

  test "should show planilla_incompatibilidad" do
    get :show, id: @planilla_incompatibilidad
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @planilla_incompatibilidad
    assert_response :success
  end

  test "should update planilla_incompatibilidad" do
    patch :update, id: @planilla_incompatibilidad, planilla_incompatibilidad: { apellido: @planilla_incompatibilidad.apellido, dni: @planilla_incompatibilidad.dni, escuela_a: @planilla_incompatibilidad.escuela_a, escuela_b: @planilla_incompatibilidad.escuela_b, escuela_c: @planilla_incompatibilidad.escuela_c, escuela_d: @planilla_incompatibilidad.escuela_d, escuela_e: @planilla_incompatibilidad.escuela_e, fecha1: @planilla_incompatibilidad.fecha1, fecha2: @planilla_incompatibilidad.fecha2, fecha_nacimiento: @planilla_incompatibilidad.fecha_nacimiento, nombre: @planilla_incompatibilidad.nombre, nota_ingreso: @planilla_incompatibilidad.nota_ingreso, numero: @planilla_incompatibilidad.numero, observaciones_inc: @planilla_incompatibilidad.observaciones_inc, observaciones_suel: @planilla_incompatibilidad.observaciones_suel, text: @planilla_incompatibilidad.text }
    assert_redirected_to planilla_incompatibilidad_path(assigns(:planilla_incompatibilidad))
  end

  test "should destroy planilla_incompatibilidad" do
    assert_difference('PlanillaIncompatibilidad.count', -1) do
      delete :destroy, id: @planilla_incompatibilidad
    end

    assert_redirected_to planilla_incompatibilidads_path
  end
end
