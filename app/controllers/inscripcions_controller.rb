class InscripcionsController < InheritedResources::Base
  skip_load_and_authorize_resource :only => :docenteInscripcion
  load_and_authorize_resource
  before_action :authenticate_user!
  
  def index
    authorize! :index, Inscripcion
  	respond_to do |format|
      format.html
      format.json { render json: InscripcionDatatable.new(view_context, { query: Inscripcion.all.order(fecha_incripcion: :desc) }) }
    end
  end

  def docenteInscripcion
    puts params[:id]
    @persona = Persona.where(id: params[:id]).first
    if !@persona.esta_en_el_padron
      flash[:error] = 'DNI Ingresado no existe en el sistema de inscripciones.'
      redirect_to :back
    else

      @inscripcion = @persona.inscripcions.first
      if !@inscripcion.nil?
        authorize! :read, @inscripcion
      end
      authorize! :read, @persona

      respond_to do |format|
        format.html
        format.pdf do
          render :pdf => 'Comprobante de inscripcion',
          :template => 'inscripcions/inscripcion.pdf.erb',
          :layout => 'pdf.html.erb',
          :orientation => 'Portrait',
          :page_size => 'Legal',
          header: {
            html: {
              template: 'layouts/_header_pdf.html.erb'
              }
            },
            :show_as_html => params[:debug].present?
        end
      end
    end
  end

  def update
    params = inscripcion_params
    params[:updated_by] = current_user.id
    @inscripcion.update(params)
    @inscripcion.updated_by = current_user.id
    respond_with(@inscripcion)
  end

  def show
    @inscripcion = Inscripcion.find(params[:id])
    redirect_to action: "docenteInscripcion", id: @inscripcion.persona.id
  end

  def new
    @concurso = Concurso.get_concurso_activo
    if @concurso.nil? 
      redirect_to request.referrer, :alert => "Sin concurso abierto para inscribirse."
    end
    @persona = Persona.where(id: params[:id]).first
    @inscripcion = @persona.inscripcions.first
    if @inscripcion.nil?
      @inscripcion = Inscripcion.new    
      @inscripcion.persona = @persona
      @inscripcion.concurso = @concurso
    else
      redirect_to action: "show", id: @inscripcion.id
    end
  end

  def create
    @inscripcion = Inscripcion.new(inscripcion_params)
    @inscripcion.fecha_incripcion = Date.current
    @inscripcion.created_by = current_user.id
    @inscripcion.save
    if @inscripcion.save
      flash[:success] = "Inscripcion registrada correctamente"
      redirect_to action: "docenteInscripcion", id: @inscripcion.persona.id
    else
      render "new"
    end
  end

  def buscar_persona
    @persona = Persona.where(:nro_documento => params[:dni]).first()
     render json: @persona    
  end

  private

  def find_inscripcion
    @persona = Persona.where(id: params[:id]).first
    @inscripcion = @persona.inscripcions.first
  end

  def set_inscripcion
    @inscripcion = Inscripcion.find(params[:id])
  end

  private
  
    def inscripcion_params
      params.require(:inscripcion).permit(
        :persona_id, 
        :region_id,
        :concurso_id,
        :ambito_id,
        :establecimiento_id,
        :cabecera, 
        :fecha_incripcion, 
        cargo_inscrip_doc_attributes: [
          :id, 
          :inscripcion_id, 
          :juntafuncion_id, 
          :opcion, 
          :_destroy, :opcion
        ]
      )
    end

end

