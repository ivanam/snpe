class CargoInscripDocsController < InheritedResources::Base
  

  def index
  	respond_to do |format|
      format.html
      format.json { render json: CargoInscripDocDatatable.new(view_context, { query: CargoInscripDoc.all }) }
    end
  end

  
  def show
  	@cargo_inscrip_docs = CargoInscripDoc.find(params[:id])
  end

  def new
    
    @cargo_inscrip_docs = CargoInscripDoc.new
    respond_with(@cargo_inscrip_docs)
  end

  def edit
    @cargo_inscrip_docs = CargoInscripDoc.find(params[:id])
  end

  def create
    
    @cargo_inscrip_docs = CargoInscripDoc.new(cargo_inscrip_doc_params)
    @cargo_inscrip_docs.save
    respond_with(@cargo_inscrip_docs)
  end

  def update
    @cargo_inscrip_docs.update(cargo_inscrip_doc_params)
    respond_with(@cargo_inscrip_docs)
  end

  def destroy
  	@cargo_inscrip_docs = CargoInscripDoc.find(params[:id])
    @cargo_inscrip_docs.destroy
    respond_to do |format|
      format.html { redirect_to cargo_inscrip_docs_url }
      format.json { head :no_content }
    end
  end

  private

    def cargo_inscrip_doc_params
      params.require(:cargo_inscrip_doc).permit(:inscripcion_id, :persona_id, :cargosnds_id, :cargo_id, :nivel_id, :opcion)
    end
end

