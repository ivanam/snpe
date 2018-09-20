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
        render :pdf => 'cv',
        :template => 'inscripcions/cv.html.erb',
        :template => 'inscripcions/cvNUEVO.pdf.erb',
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
    # if current_user.id != nil 
    #    @inscripcion = Inscripcion.new
    #    @persona=Persona.where(:user_id => current_user.id).first()
    #    else
       @inscripcion = Inscripcion.new  
       @persona=Persona.find(21435)
       @inscripcion.persona_id = @persona.id
       # @inscripcion.user_id = @current_user.id
    # end
 end

  def create
    # leer aca la persona a partir del current user 
    @inscripcion = Inscripcion.new(inscripcion_params)
    @inscripcion.save  

    if @inscripcion.save
      redirect_to @inscripcion # show
      #redirect_to cv_path (@inscripcion.persona_id)
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
    # @rubro_persona = Rubro.where(:persona_id => params[:dni]).first()
    # render json: @rubro_persona
  end

  def cv
    @persona = Persona.find(21435)
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'cv',
        :template => 'inscripcions/cv.html.erb',
        :template => 'inscripcions/cv.pdf.erb',
        :layout => 'pdf.html.erb',
        :orientation => 'Portrait',# default Portrait
        :page_size => 'Legal', # default A4
        header: {
                html: {
                  template: 'layouts/_header_pdf.html.erb'
                }
              },
        :show_as_html => params[:debug].present?
      end
    end
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

