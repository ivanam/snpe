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
    
  def destroy
    @rubro = Rubro.find(params[:id])  
    @inscripcion = @rubro.persona.inscripcions.first
    if !@inscripcion.nil?
      cargos_inscriptos = @inscripcion.cargo_inscrip_doc.map do | cargo_inscripto |
        cargo_inscripto.juntafuncion_id
      end
      if  cargos_inscriptos.include?(@rubro.juntafuncion_id) 
        flash[:error] = "No se pudo eliminar el puntaje, ya existe una inscripcion."
        redirect_to action: "show", id: @rubro.id
      else
        @rubro.destroy      
        respond_with(@rubro)    
      end
    else
      @rubro.destroy      
      respond_with(@rubro)
    end
    
    
  end

  private

    def rubro_params
      params.require(:rubro).permit(:persona_id, :region_id, :juntafuncion_id, :rubro_titulo, :promedio,
        :ant_doc, :rubro_gestion, :rubro_ser_prest, :rubro_residencia, :rubro_concepto, :rubro_cursos, 
        :total, :titular,
        )
    end
end
