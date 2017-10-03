require 'test_helper'

class TipoHorasControllerTest < ActionController::TestCase
  setup do
    @tipo_hora = tipo_horas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_horas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_hora" do
    assert_difference('TipoHora.count') do
      post :create, tipo_hora: { nombre: @tipo_hora.nombre }
    end

    assert_redirected_to tipo_hora_path(assigns(:tipo_hora))
  end

  test "should show tipo_hora" do
    get :show, id: @tipo_hora
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_hora
    assert_response :success
  end

  test "should update tipo_hora" do
    patch :update, id: @tipo_hora, tipo_hora: { nombre: @tipo_hora.nombre }
    assert_redirected_to tipo_hora_path(assigns(:tipo_hora))
  end

  test "should destroy tipo_hora" do
    assert_difference('TipoHora.count', -1) do
      delete :destroy, id: @tipo_hora
    end

    assert_redirected_to tipo_horas_path
  end
end
