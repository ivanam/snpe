class EspecialidadsController < InheritedResources::Base
      
  def index
    respond_to do |format|
      format.html
      format.json { render json: EspecialidadDatatable.new(view_context, { query: Especialidad.all }) }
    end
  end

  def show
    respond_with(@especialidad)
  end

  def new
    @especialidad = Especialidad.new
    respond_with(@especialidad)
  end

  def edit
  end

  def create
    @especialidad = Especialidad.new(especialidad_params)
    @especialidad.save
    respond_with(@especialidad)
  end

  def update
    @especialidad.update(especialidad_params)
    respond_with(@especialidad)
  end

  def destroy
    @especialidad.destroy
    respond_with(@especialidad)
  end


  private
   
    def especialidad_params
      params.require(:especialidad).permit(:nombre)
    end
end

