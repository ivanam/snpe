class ConcursosController < InheritedResources::Base
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    respond_to do |format|
    	format.html
    	format.json { render json: ConcursoDatatable.new(view_context, { query:Concurso.all }) }
    end
  end

  def estadisticas
    id = params[:id]
    @concurso = Concurso.where(id: id).first
    respond_to do |format|
      format.html
      format.json { render json: @concurso }
    end
  end

  def destroy
    if @concurso.inscripcions.size > 0
      s = @concurso.inscripcions.size
      @concurso.inscripcions.each do |inscripcion|
        inscripcion.destroy
      end
      flash[:warning] = "Se eliminaron #{s} inscripciones del concurso."
    end    
    @concurso.destroy
    respond_with(@concurso)
  end

  private

  def concurso_params
    params.require(:concurso).permit(:fecha_concurso, :fecha_inicio, :fecha_fin, :descripcion)
  end
end

