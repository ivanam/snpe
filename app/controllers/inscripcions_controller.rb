class InscripcionsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_action :permisos_index, only: [:index]
  before_action :permisos_edit, only: [:edit]

  before_action :permisos_get, only: [:new]
  before_action :permisos_post, only: [:create, :update]


  def index
  	respond_to do |format|
      format.html
      format.json { render json: InscripcionDatatable.new(view_context, { query: Inscripcion.all.order(fecha_incripcion: :desc) }) }
    end
  end

  def docenteInscripcion
    puts params[:id]
    @persona = Persona.where(id: params[:id]).first
    @inscripcion = @persona.inscripcions.first
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

  def show
    @inscripcion = Inscripcion.find(params[:id])
    redirect_to action: "docenteInscripcion", id: @inscripcion.persona.id
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

    def permisos_index
        if not current_user.role? :Junta 
            redirect_to root_path, :alert => "Access denied."
        end
    end

    def permisos_edit
      if current_user.role? :UserJunta
        @inscripcion = Inscripcion.find(params[:id])  
        @persona = @inscripcion.persona
        if @persona.id != current_user.get_persona.id
          flash[:error]= "Access denied."
          redirect_to :back
          #redirect_to root_path, :alert => "Access denied."
        end
      elsif not current_user.role? :Junta
        redirect_to root_path, :alert => "Access denied."
      end  
    end

    def permisos_get
      if current_user.role? :UserJunta
        p1 = current_user.get_persona.id
        p2 = Persona.where(id: params[:id]).first.id
        if p1 != p2
          flash[:error]= "Access denied."
          redirect_to :back
          #redirect_to root_path, :alert => "Access denied."
        end        
      else
        if not current_user.role? :Junta
            redirect_to root_path, :alert => "Access denied."
        end
      end
    end

    def permisos_post
      if current_user.role? :UserJunta
        p1 = current_user.get_persona.id
        p2 = Persona.where(id: inscripcion_params[:persona_id]).first.id
        if p1 != p2
          flash[:error]= "Access denied."
          redirect_to :back
          #redirect_to root_path, :alert => "Access denied."
        end        
      else
        if not current_user.role? :Junta 
          redirect_to root_path, :alert => "Access denied."
        end
      end
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

