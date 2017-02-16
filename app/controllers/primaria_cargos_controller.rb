class PrimariaCargosController < InheritedResources::Base

  def index
  	respond_to do |format|
      format.html
      format.json { render json: PrimariaCargoDatatable.new(view_context, { query: PrimariaCargo.all.order(id: :desc) }) }
    end
  end

 def show
  	@primaria_cargo = PrimariaCargo.find(params[:id])
  end

  private

    def primaria_cargo_params
      params.require(:primaria_cargo).permit(:descripcion, :codigo_nomen, :cargo_inscrip_doc_id, :inscripcion_id, :funcion_id)
    end
end

