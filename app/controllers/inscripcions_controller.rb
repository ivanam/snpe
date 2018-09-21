class InscripcionsController < InheritedResources::Base

  def index
  	respond_to do |format|
      format.html
      format.json { render json: InscripcionDatatable.new(view_context, { query: Inscripcion.all.order(fecha_incripcion: :desc) }) }
    end
  end

  def show
    @inscripcion = Inscripcion.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'Comprobante de inscripcion',
        :template => 'inscripcions/cv.html.erb',
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

  def new
    @persona = Persona.where(id: params[:id]).first
    @inscripcion = @persona.inscripcions.first
    if @inscripcion.nil?
      @inscripcion = Inscripcion.new    
      @inscripcion.persona_id = @persona.id
    else
      redirect_to action: "show", id: @inscripcion.id
    end
  end

  def create
    @inscripcion = Inscripcion.new(inscripcion_params)
    @inscripcion.save
    if @inscripcion.save
      redirect_to @inscripcion      
    else
      render "new"
    end
  end

  def destroy
  	@inscripcion = Inscripcion.find(params[:id])
    @inscripcion.destroy
    respond_to do |format|
      format.html { redirect_to inscripcions_url }
      format.json { head :no_content }
    end
  end

  def buscar_persona
    @persona = Persona.where(:nro_documento => params[:dni]).first()
     render json: @persona    
  end

  private
    def set_inscripcion
      @inscripcion = Inscripcion.find(params[:id])
    end

  private
    def inscripcion_params
      params.require(:inscripcion).permit(
        :persona_id, 
        :region_id,
        :cabecera, 
        :fecha_incripcion, 
        cargo_inscrip_doc_attributes: [
          :id, 
          :inscripcion_id, 
          :funcion_id, 
          :opcion, 
          :_destroy, :opcion
        ]
      )
    end
end

