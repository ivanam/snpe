require 'test_helper'

class DesplieguesControllerTest < ActionController::TestCase
  setup do
    @despliegue = despliegues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:despliegues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create despliegue" do
    assert_difference('Despliegue.count') do
      post :create, despliegue: { anio: @despliegue.anio, carga_horaria: @despliegue.carga_horaria, materia_id: @despliegue.materia_id, plan_id: @despliegue.plan_id }
    end

    assert_redirected_to despliegue_path(assigns(:despliegue))
  end

  test "should show despliegue" do
    get :show, id: @despliegue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @despliegue
    assert_response :success
  end

  test "should update despliegue" do
    patch :update, id: @despliegue, despliegue: { anio: @despliegue.anio, carga_horaria: @despliegue.carga_horaria, materia_id: @despliegue.materia_id, plan_id: @despliegue.plan_id }
    assert_redirected_to despliegue_path(assigns(:despliegue))
  end

  test "should destroy despliegue" do
    assert_difference('Despliegue.count', -1) do
      delete :destroy, id: @despliegue
    end

    assert_redirected_to despliegues_path
  end
end
