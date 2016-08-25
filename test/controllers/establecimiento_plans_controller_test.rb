require 'test_helper'

class EstablecimientoPlansControllerTest < ActionController::TestCase
  setup do
    @establecimiento_plan = establecimiento_plans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:establecimiento_plans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create establecimiento_plan" do
    assert_difference('EstablecimientoPlan.count') do
      post :create, establecimiento_plan: { establecimiento_id: @establecimiento_plan.establecimiento_id, plan_id: @establecimiento_plan.plan_id }
    end

    assert_redirected_to establecimiento_plan_path(assigns(:establecimiento_plan))
  end

  test "should show establecimiento_plan" do
    get :show, id: @establecimiento_plan
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @establecimiento_plan
    assert_response :success
  end

  test "should update establecimiento_plan" do
    patch :update, id: @establecimiento_plan, establecimiento_plan: { establecimiento_id: @establecimiento_plan.establecimiento_id, plan_id: @establecimiento_plan.plan_id }
    assert_redirected_to establecimiento_plan_path(assigns(:establecimiento_plan))
  end

  test "should destroy establecimiento_plan" do
    assert_difference('EstablecimientoPlan.count', -1) do
      delete :destroy, id: @establecimiento_plan
    end

    assert_redirected_to establecimiento_plans_path
  end
end
