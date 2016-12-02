class TituloPersonasController < InheritedResources::Base
  
   def index
  	respond_to do |format|
      format.html
      format.json { render json: TituloPersonaDatatable.new(view_context, { query: TituloPersona.all }) }
    end
  end

  

  def show
  	@titulo_persona = TituloPersona.find(params[:id])
  end

  def new
    @titulo_persona = TituloPersona.new
    respond_with(@titulo_persona)
  end

  def edit
    @titulo_persona = TituloPersona.find(params[:id])
  end

  def create
    debugger
    @titulo_persona = TituloPersona.new(titulo_persona_params)
    @titulo_persona.save
    respond_with(@titulo_persona)
  end

  def update
    @titulo_persona.update(titulo_persona_params)
    respond_with(@titulo_persona)
  end

  def destroy
  	@titulo_persona = TituloPersona.find(params[:id])
    @titulo_persona.destroy
    respond_to do |format|
      format.html { redirect_to titulo_persona_url }
      format.json { head :no_content }
    end
  end
  private

    def titulo_persona_params
      params.require(:titulo_persona).permit(:titulo_id, :persona_id)
    end
end

