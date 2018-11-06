class PersonasController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: PersonaDatatable.new(view_context) }
    end
  end

  def show
    respond_with(@persona)
  end

  def new
    @persona = Persona.new
    @persona.user_id = current_user.id
    respond_with(@persona)
  end

  def edit
  end

  def create
    @persona = Persona.new(persona_params)
    @persona.save
     respond_with(@persona)
  end

  def editar_persona
  end

  def update
    @persona.update(persona_params)
    if request.referrer.include? "inscripcions"
      if !@persona.valid?
        @persona.errors.full_messages.each do |msg| 
          flash[:error] = msg
        end
      else
        flash[:success] = 'Lugar de titularidad guardado correctamente'
      end
      redirect_to :back
    else
      respond_with(@persona)
    end
  end

  def destroy
    @persona.destroy
    respond_with(@persona)
  end

  private
    def set_persona
      @persona = Persona.find(params[:id])
    end

    def persona_params
      params.require(:persona).permit(
        :apellidos, 
        :anio, 
        :mes, 
        :dia, 
        :calle, 
        :depto, 
        :email, 
        :estado_civil_id, 
        :fecha_nacimiento, 
        :localidad_id, 
        :nombres, 
        :nro_calle, 
        :nro_documento, 
        :piso, 
        :sexo_id, 
        :situacion_revista_id, 
        :telefono_contacto, 
        :tipo_documento_id, 
        :cuil,
        rubros_attributes: [
          :id, 
          :ambito_id, 
          :establecimiento_id, 
          :_destroy, :opcion
        ]
      )

  end

end
