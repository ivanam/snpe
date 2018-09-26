class ConcursosController < InheritedResources::Base
	

	def index
		respond_to do |format|
      		format.html
      		format.json { render json: ConcursoDatatable.new(view_context, { query:Concurso.all }) }
    	end
  	end

  private

    def concurso_params
      params.require(:concurso).permit(:fecha_concurso, :fecha_inicio, :fecha_fin, :descripcion)
    end
end

