require 'test_helper'

class CargoInscripDocsControllerTest < ActionController::TestCase
  setup do
    @cargo_inscrip_doc = cargo_inscrip_docs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargo_inscrip_docs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargo_inscrip_doc" do
    assert_difference('CargoInscripDoc.count') do
      post :create, cargo_inscrip_doc: { cargo_id: @cargo_inscrip_doc.cargo_id, cargo_id: @cargo_inscrip_doc.cargo_id, cargosnds_id: @cargo_inscrip_doc.cargosnds_id, cargosnds_id: @cargo_inscrip_doc.cargosnds_id, incripcion_id: @cargo_inscrip_doc.incripcion_id, inscripcion_id: @cargo_inscrip_doc.inscripcion_id, nivel_id: @cargo_inscrip_doc.nivel_id, nivel_id: @cargo_inscrip_doc.nivel_id, persona_id: @cargo_inscrip_doc.persona_id, persona_id: @cargo_inscrip_doc.persona_id }
    end

    assert_redirected_to cargo_inscrip_doc_path(assigns(:cargo_inscrip_doc))
  end

  test "should show cargo_inscrip_doc" do
    get :show, id: @cargo_inscrip_doc
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cargo_inscrip_doc
    assert_response :success
  end

  test "should update cargo_inscrip_doc" do
    patch :update, id: @cargo_inscrip_doc, cargo_inscrip_doc: { cargo_id: @cargo_inscrip_doc.cargo_id, cargo_id: @cargo_inscrip_doc.cargo_id, cargosnds_id: @cargo_inscrip_doc.cargosnds_id, cargosnds_id: @cargo_inscrip_doc.cargosnds_id, incripcion_id: @cargo_inscrip_doc.incripcion_id, inscripcion_id: @cargo_inscrip_doc.inscripcion_id, nivel_id: @cargo_inscrip_doc.nivel_id, nivel_id: @cargo_inscrip_doc.nivel_id, persona_id: @cargo_inscrip_doc.persona_id, persona_id: @cargo_inscrip_doc.persona_id }
    assert_redirected_to cargo_inscrip_doc_path(assigns(:cargo_inscrip_doc))
  end

  test "should destroy cargo_inscrip_doc" do
    assert_difference('CargoInscripDoc.count', -1) do
      delete :destroy, id: @cargo_inscrip_doc
    end

    assert_redirected_to cargo_inscrip_docs_path
  end
end
