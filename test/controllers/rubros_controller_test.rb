require 'test_helper'

class RubrosControllerTest < ActionController::TestCase
  setup do
    @rubro = rubros(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rubros)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rubro" do
    assert_difference('Rubro.count') do
      post :create, rubro: { ant_doc: @rubro.ant_doc, escuela_id: @rubro.escuela_id, establecimiento_id: @rubro.establecimiento_id, persona_id: @rubro.persona_id, pesona_id: @rubro.pesona_id, promedio: @rubro.promedio, rubro_asis_perf: @rubro.rubro_asis_perf, rubro_concepto: @rubro.rubro_concepto, rubro_cursos: @rubro.rubro_cursos, rubro_gestion: @rubro.rubro_gestion, rubro_residencia: @rubro.rubro_residencia, rubro_ser_prest: @rubro.rubro_ser_prest, rubro_titulo: @rubro.rubro_titulo, rubro_titulo: @rubro.rubro_titulo, total: @rubro.total }
    end

    assert_redirected_to rubro_path(assigns(:rubro))
  end

  test "should show rubro" do
    get :show, id: @rubro
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rubro
    assert_response :success
  end

  test "should update rubro" do
    patch :update, id: @rubro, rubro: { ant_doc: @rubro.ant_doc, escuela_id: @rubro.escuela_id, establecimiento_id: @rubro.establecimiento_id, persona_id: @rubro.persona_id, pesona_id: @rubro.pesona_id, promedio: @rubro.promedio, rubro_asis_perf: @rubro.rubro_asis_perf, rubro_concepto: @rubro.rubro_concepto, rubro_cursos: @rubro.rubro_cursos, rubro_gestion: @rubro.rubro_gestion, rubro_residencia: @rubro.rubro_residencia, rubro_ser_prest: @rubro.rubro_ser_prest, rubro_titulo: @rubro.rubro_titulo, rubro_titulo: @rubro.rubro_titulo, total: @rubro.total }
    assert_redirected_to rubro_path(assigns(:rubro))
  end

  test "should destroy rubro" do
    assert_difference('Rubro.count', -1) do
      delete :destroy, id: @rubro
    end

    assert_redirected_to rubros_path
  end
end
