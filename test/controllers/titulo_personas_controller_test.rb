require 'test_helper'

class TituloPersonasControllerTest < ActionController::TestCase
  setup do
    @titulo_persona = titulo_personas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:titulo_personas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create titulo_persona" do
    assert_difference('TituloPersona.count') do
      post :create, titulo_persona: { persona_id: @titulo_persona.persona_id, persona_id: @titulo_persona.persona_id, titulo_id: @titulo_persona.titulo_id, titulo_id: @titulo_persona.titulo_id }
    end

    assert_redirected_to titulo_persona_path(assigns(:titulo_persona))
  end

  test "should show titulo_persona" do
    get :show, id: @titulo_persona
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @titulo_persona
    assert_response :success
  end

  test "should update titulo_persona" do
    patch :update, id: @titulo_persona, titulo_persona: { persona_id: @titulo_persona.persona_id, persona_id: @titulo_persona.persona_id, titulo_id: @titulo_persona.titulo_id, titulo_id: @titulo_persona.titulo_id }
    assert_redirected_to titulo_persona_path(assigns(:titulo_persona))
  end

  test "should destroy titulo_persona" do
    assert_difference('TituloPersona.count', -1) do
      delete :destroy, id: @titulo_persona
    end

    assert_redirected_to titulo_personas_path
  end
end
