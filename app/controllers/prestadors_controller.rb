class PrestadorsController < InheritedResources::Base

  private
    
   def index
    respond_to do |format|
      format.html
      format.json { render json: PrestadorDatatable.new(view_context, { query: Prestador.all }) }
    end
  end

  def show
    respond_with(@prestador)
  end

  def new
    @prestador = Prestador.new
    respond_with(@prestador)
  end

  def edit
  end

  def create
    @prestador = Prestador.new(prestador_params)
    @prestador.save
    respond_with(@prestador)
  end

  def update
    @prestador.update(prestador_params)
    respond_with(@prestador)
  end

  def destroy
    @prestador.destroy
    respond_with(@prestador)
  end

  private
    def set_prestador
      @prestador = Prestador.find(params[:id])
    end

    def prestador_params
      params.require(:prestador).permit(:nombre, :matricula, :especialidad_id)
    end


end

