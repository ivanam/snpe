class TitulosController < InheritedResources::Base
  
  def index
  	respond_to do |format|
      format.html
      format.json { render json: TituloDatatable.new(view_context, { query: Titulo.all }) }
    end
  end

  

  def show
  	@titulo = Titulo.find(params[:id])
  end

  def new
    @titulo = Titulo.new
    respond_with(@titulo)
  end

  def edit
    @Titulo = Titulo.find(params[:id])
  end

  def create
    @titulo = Titulo.new(titulo_params)
    @titulo.save
    respond_with(@titulo)
  end

  def update
    @titulo.update(titulo_params)
    respond_with(@titulo)
  end

  def destroy
  	@titulo = titulo.find(params[:id])
    @titulo.destroy
    respond_to do |format|
      format.html { redirect_to titulos_url }
      format.json { head :no_content }
    end
  end

  private

    def titulo_params
      params.require(:titulo).permit(:nombre, :persona_id)
    end
end

