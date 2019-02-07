class RubrosController < InheritedResources::Base
  before_action :authenticate_user!
  load_and_authorize_resource
  
  def index
  	respond_to do |format|
      format.html
      format.json { render json: RubroDatatable.new(view_context, { query: Rubro.all }) }
    end
  end

  def update
    params = rubro_params
    params[:updated_by] = current_user.id
    @rubro.update(params)
    respond_with(@rubro)
  end

  def create
    @rubro = Rubro.new(rubro_params)
    @rubro.created_by = current_user.id
    @rubro.save
    respond_with(@rubro)
  end
  
  private

    def rubro_params
      params.require(:rubro).permit(:persona_id, :region_id, :juntafuncion_id, :rubro_titulo, :promedio,
        :ant_doc, :rubro_gestion, :rubro_ser_prest, :rubro_residencia, :rubro_concepto, :rubro_cursos, 
        :total, :titular,
        )
    end
end
