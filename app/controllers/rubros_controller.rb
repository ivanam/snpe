class RubrosController < InheritedResources::Base
  before_filter :authenticate_user!
  before_action :junta_only

  #before_action :rubro, only: [:show, :edit, :update]

  def index
  	respond_to do |format|
      format.html
      format.json { render json: RubroDatatable.new(view_context, { query: Rubro.all.order(total: :desc) }) }
    end
  end


  
  def new
    @rubro = Rubro.new
    respond_with(@articulo)
  end
   
 def edit
    @rubro = Rubro.find(params[:id])
    #@rubro.total =  @rubro.rubro_titulo.to_f + @rubro.rubro_concepto.to_f + @rubro.rubro_asis_perf.to_f + @rubro.rubro_ser_prest.to_f +  @rubro.promedio.to_f + @rubro.rubro_residencia.to_f + @rubro.rubro_gestion.to_f + @rubro.rubro_cursos.to_f + @rubro.ant_doc.to_f
    #@rubro.save
  end 

  def create
    @rubro = Rubro.new(rubro_params)
    @rubro.total =  @rubro.rubro_titulo.to_f + @rubro.rubro_concepto.to_f + @rubro.rubro_asis_perf.to_f + @rubro.rubro_ser_prest.to_f +  @rubro.promedio.to_f + @rubro.rubro_residencia.to_f + @rubro.rubro_gestion.to_f + @rubro.rubro_cursos.to_f + @rubro.ant_doc.to_f
    @rubro.save
    respond_with(@rubro)
  end

  def update
    @rubro = Rubro.find(params[:id])
    @rubro.update(rubro_params)
    @rubro.total =  @rubro.rubro_titulo.to_f + @rubro.rubro_concepto.to_f + @rubro.rubro_asis_perf.to_f + @rubro.rubro_ser_prest.to_f +  @rubro.promedio.to_f + @rubro.rubro_residencia.to_f + @rubro.rubro_gestion.to_f + @rubro.rubro_cursos.to_f + @rubro.ant_doc.to_f
    @rubro.save
    respond_with(@rubro)
  end
    
  def show
  	@rubro = Rubro.find(params[:id])
  end

  def destroy
    redirect_to rubros_path, :alert => "Operacion no permitida."
  end

  private

    def junta_only
      if not current_user.tiene_rol('Junta')
        redirect_to root_path, :alert => "Access denied."
      end
    end

    def rubro_params
      params.require(:rubro).permit(:rubro_titulo, :rubro_concepto, :rubro_asis_perf, :rubro_ser_prest, :rubro_residencia, :rubro_gestion, :rubro_cursos, :ant_doc, :total, :promedio, :persona_id, :establecimiento_id, :nombre_apellido)
    end
end

