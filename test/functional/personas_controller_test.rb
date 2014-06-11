require 'test_helper'

class PersonasControllerTest < ActionController::TestCase
  setup do
    @persona = personas(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:personas)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create persona" do
    assert_difference('Persona.count') do
      post :create, persona: { apellidos: @persona.apellidos, calle: @persona.calle, depto: @persona.depto, email: @persona.email, estado_civil_id: @persona.estado_civil_id, fecha_nacimiento: @persona.fecha_nacimiento, localidad_id: @persona.localidad_id, nombres: @persona.nombres, nro_calle: @persona.nro_calle, nro_documento: @persona.nro_documento, piso: @persona.piso, sexo_id: @persona.sexo_id, situacion_revista_id: @persona.situacion_revista_id, telefono_contacto: @persona.telefono_contacto, tipo_documento_id: @persona.tipo_documento_id }
    end

    assert_redirected_to persona_path(assigns(:persona))
  end

  test "should show persona" do
    get :show, id: @persona
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @persona
    assert_response :success
  end

  test "should update persona" do
    put :update, id: @persona, persona: { apellidos: @persona.apellidos, calle: @persona.calle, depto: @persona.depto, email: @persona.email, estado_civil_id: @persona.estado_civil_id, fecha_nacimiento: @persona.fecha_nacimiento, localidad_id: @persona.localidad_id, nombres: @persona.nombres, nro_calle: @persona.nro_calle, nro_documento: @persona.nro_documento, piso: @persona.piso, sexo_id: @persona.sexo_id, situacion_revista_id: @persona.situacion_revista_id, telefono_contacto: @persona.telefono_contacto, tipo_documento_id: @persona.tipo_documento_id }
    assert_redirected_to persona_path(assigns(:persona))
  end

  test "should destroy persona" do
    assert_difference('Persona.count', -1) do
      delete :destroy, id: @persona
    end

    assert_redirected_to personas_path
  end
end
