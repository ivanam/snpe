class InscripcionsController < InheritedResources::Base

  
  def index
  	respond_to do |format|
      format.html
      format.json { render json: InscripcionDatatable.new(view_context, { query: Inscripcion.all.order(fecha_incripcion: :desc) }) }
    end
  end

  def show
  	@inscripcion = Inscripcion.find(params[:id])
  end

  def new
    @inscripcion = Inscripcion.new
    @titulo = Titulo.new
    @persona=Persona.find(params[:persona_id])
    @inscripcion.persona_id = @persona.id
    @titulo.persona_id = @persona.id


  end

  def edit
    @inscripcion = Inscripcion.find(params[:id])
    @titulo = @inscripcion.persona.titulo
  end

  def create
    @inscripcion = Inscripcion.new(inscripcion_params)
    @inscripcion.save
    debugger
    #@titulo = Titulo.new(titulo_params)
    #@titulo.persona_id = @inscripcion.persona_id
    # @titulo.save
    # if params[:inscripcion][:titulo_personas_attributes].count > 0
    #   params[:inscripcion][:titulo_personas_attributes].each do |t|
    #     TituloPersona.create(:titulo_id => t.last[:titulo_id], :persona_id => @inscripcion.persona_id)
    #   end
    # end
    # @id=0
    # if params[:inscripcion][:cargo_inscrip_doc_attributes].count > 0
    #   debugger
    #   params[:inscripcion][:cargo_inscrip_doc_attributes].each do |pe|
    #    CargoInscripDoc.create(:inscripcion_id => @inscripcion.id, 
    #                           :persona_id => @inscripcion.persona_id, 
    #                           :cargosnds_id => pe.last[:cargosnds_id], 
    #                           :cargo_id => pe.last[:cargo_id], 
    #                           :nivel_id => @id)
    #   end
    # end
    respond_to do |format|
    format.html { redirect_to cv_path (@inscripcion.persona_id) }
    #respond_with(@inscripcion)
    end
  end

  def update
    @inscripcion.update(inscripcion_params)
    respond_with(@inscripcion)
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

  def cv
    @persona = Persona.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'cv',
        :template => 'inscripcions/cv.html.erb',
        :template => 'inscripcions/cv.pdf.erb',
        :layout => 'pdf.html.erb',
        :page_size=>  'A4',
        :margin => {:top=> 0,
                   :bottom => 0,
                   :left => 2,
                   :right => 2}
        #:layout => 'application.html.erb',
      end
    end
  end

  private
    def set_inscripcion
      @inscripcion = Inscripcion.find(params[:id])
    end

  private

    def inscripcion_params
      params.require(:inscripcion).permit(:pesona_id, :establecimiento_id, :funcion_id, :nivel_id, :escuela_titular, :serv_activo, :lugar_serv_act, :documentacion, :rubro_id, :fecha_incripcion, :rubro_id, :persona_id, :establecimiento_id, :funcion_id, :nivel_id, :cabecera, titulo_persona_attributes: [:id, :titulo_id, :persona_id, :_destroy], cargo_inscrip_doc_attributes: [:id, :inscripcion_id, :persona_id, :cargosnds_id, :cargo_id, :nivel_id, :_destroy])
    end
end

