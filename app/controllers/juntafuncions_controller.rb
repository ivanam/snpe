class JuntafuncionsController < InheritedResources::Base
  load_and_authorize_resource
  def index
    respond_to do |format|
      format.html
      format.json { render json: JuntafuncionDatatable.new(view_context, { query: Juntafuncion.all.order(descripcion: :desc) }) }
    end
  end
  
  private

    def juntafuncion_params
      params.require(:juntafuncion).permit(:descripcion)
    end
end

