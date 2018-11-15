require 'test_helper'

class ConcursosControllerTest < ActionController::TestCase
  setup do
    @concurso = concursos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:concursos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create concurso" do
    assert_difference('Concurso.count') do
      post :create, concurso: { descripcion: @concurso.descripcion, fecha_concurso: @concurso.fecha_concurso, fecha_fin: @concurso.fecha_fin, fecha_inicio: @concurso.fecha_inicio }
    end

    assert_redirected_to concurso_path(assigns(:concurso))
  end

  test "should show concurso" do
    get :show, id: @concurso
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @concurso
    assert_response :success
  end

  test "should update concurso" do
    patch :update, id: @concurso, concurso: { descripcion: @concurso.descripcion, fecha_concurso: @concurso.fecha_concurso, fecha_fin: @concurso.fecha_fin, fecha_inicio: @concurso.fecha_inicio }
    assert_redirected_to concurso_path(assigns(:concurso))
  end

  test "should destroy concurso" do
    assert_difference('Concurso.count', -1) do
      delete :destroy, id: @concurso
    end

    assert_redirected_to concursos_path
  end
end
