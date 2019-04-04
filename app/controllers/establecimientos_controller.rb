class EstablecimientosController < ApplicationController
  before_action :set_establecimiento, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  skip_authorize_resource :only => [:establecimientos_de_usuario, :seleccionar, :pof, :pof_excel]
  
  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: EstablecimientoDatatable.new(view_context) }
    end
  end

  def show
    respond_with(@establecimiento)
  end

  def new
    @establecimiento = Establecimiento.new
    respond_with(@establecimiento)
  end

  def edit
  end

  def create
    @establecimiento = Establecimiento.new(establecimiento_params)
    @establecimiento.save
    respond_with(@establecimiento)
  end

  def update
    @establecimiento.update(establecimiento_params)
    respond_with(@establecimiento)
  end

  def destroy
    @establecimiento.destroy
    respond_with(@establecimiento)
  end

  def establecimientos_de_usuario
    establecimientos = establecimientos_permitidos
    if params[:region] != "" and params[:region] != nil and params[:region] != "undefined"
      localidad_ids = Localidad.where(region_id: params[:region]).map(&:id)
      establecimientos = establecimientos.where(localidad_id: localidad_ids)
    end
    respond_to do |format|
      format.html
      format.json { render json: EstablecimientoUserDatatable.new(view_context, { query: establecimientos }) }
    end
  end

  def seleccionar
    respond_to do |format|
      session[:establecimiento] = params[:id]      
      format.html
      format.html { redirect_to establecimientos_de_usuario_path, notice: 'Organización seleccionada' }
    end
  end

  def pof
    return true
  end

  def pof_excel
    respond_to do |format|
      format.xls
    end
  end

 
  private
    def set_establecimiento
      @establecimiento = Establecimiento.find(params[:id])
    end

    def establecimiento_params
      params.require(:establecimiento).permit(:codigo_jurisdiccional, :cue, :anexo, :cue_anexo, :sector, :ambito, :nombre, :localidad_id, :domicilio, :responsable, :tipo, :zona, :cuise, :alta, :baja, :dependencia, :email, :isotipo, :nivel_id, :ift, :numero, :privada, :rght, :sistema, :organizacion_id)
    end
    
    def validar(establecimiento)
      if session[:establecimiento].to_i != establecimiento.id
        redirect_to root_url, alert: "Usted no está autorizado para acceder a esta página."
        return false
      else
        return true
      end
    end
end
