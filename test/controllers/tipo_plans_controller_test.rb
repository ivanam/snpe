require 'test_helper'

class TipoPlansControllerTest < ActionController::TestCase
  setup do
    @tipo_plan = tipo_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipo_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_plan" do
    assert_difference('TipoPlan.count') do
      post :create, tipo_plan: { nombre: @tipo_plan.nombre }
    end

    assert_redirected_to tipo_plan_path(assigns(:tipo_plan))
  end

  test "should show tipo_plan" do
    get :show, id: @tipo_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_plan
    assert_response :success
  end

  test "should update tipo_plan" do
    patch :update, id: @tipo_plan, tipo_plan: { nombre: @tipo_plan.nombre }
    assert_redirected_to tipo_plan_path(assigns(:tipo_plan))
  end

  test "should destroy tipo_plan" do
    assert_difference('TipoPlan.count', -1) do
      delete :destroy, id: @tipo_plan
    end

    assert_redirected_to tipo_plans_path
  end
end
