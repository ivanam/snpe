class LicenciaController < ApplicationController
  before_action :set_licencium, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: LicenciaDatatable.new(view_context, { query: Licencium.all }) }
    end
  end

  def show
    respond_with(@licencium)
  end

  def new
    @licencium = Licencium.new
    respond_with(@licencium)
  end

  def edit
  end

  def create
    @licencium = Licencium.new(licencium_params)
    @licencium.save
    respond_with(@licencium)
  end

  def update
    @licencium.update(licencium_params)
    respond_with(@licencium)
  end

  def destroy
    @licencium.destroy
    respond_with(@licencium)
  end

  #Reporte de todas las licencias de todos los establecimientos
  def listado_licencias
     client = Mysql2::Client.new(:host => "127.0.0.1", :username => "root", :password => "root", :database => "snpe")
     @res= client.query("select * from snpe.licencia", :cast_booleans => true)
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaDatatable.new(view_context, { query: listado_de_licencias}) }
    end
  end

  
  def cargos_licencia_permitida
    @dni=params[:dni]
    respond_to do |format|
      format.json { render json: CargosLicenciaPermitidaDatatable.new(view_context, { query: cargos_persona_permitida(@dni)}) }
    end
  end

  def cargos_no_docentes_licencia_permitida
    @dni=params[:dni]
    respond_to do |format|
        format.json { render json: CargoNoDocentesLicenciaPermitidaDatatable.new(view_context, { query: cargos_no_docente_persona_permitida(@dni)}) }
    end
  end

  def altas_bajas_horas_licencia_permitida
    @dni=params[:dni]
    respond_to do |format|
      format.json { render json: AltasBajasHoraLicenciaPermitidaDatatable.new(view_context, { query: horas_persona_permitida(@dni)}) }
    end
  end

  def licencia_dadas
    @dni=params[:dni]
    #@altas = Licencium.where{(altas_bajas_hora_id == AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))) | (cargo_id == Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])))}
    respond_to do |format|
      format.json { render json: LicenciaDatatable.new(view_context, { query: licencias(@dni)}) }
    end
  end 

  def guardar_licencia_horas
    @licencia = Licencium.create(altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente")
    render json: 0
  end 

  def guardar_licencia_cargos
    @licencia = Licencium.create(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente")
    render json: 0
  end
   
   def guardar_licencia_cargos_no_docentes
    @licencia = Licencium.create(cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente")
    render json: 0
  end
  def guardar_licencia_final
    @licencia = Licencium.where(id: params[:id_lic]).first
    @licencia.update(:vigente => "Finalizada")
    render json: 0
  end 

  def cancelar_licencia
    @licencia = Licencium.where(id: params[:id_lic]).first
    @licencia.update!(:vigente => "Cancelada")
    render json: 0
  end

  def buscar_articulo_dias_hora
    @licencia_hora = Licencium.where(altas_bajas_hora_id: params[:id_horas])
    @licencia_articulo = @licencia_hora.where(articulo_id: params[:id_articulo], vigente: "Finalizada")
    @dias=0
    @licencia_articulo.each do |l|
      @dias = @dias + (l.fecha_hasta - l.fecha_desde).to_i + 1
    end
   
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias - @dias
    render json:  @dias_disponibles
  end

  def buscar_articulo_dias_cargo
    @licencia_cargo = Licencium.where(cargo_id: params[:id_cargos])
    @licencia_articulo = @licencia_cargo.where(articulo_id: params[:id_articulo], vigente: "Finalizada")
    @dias=0
    @licencia_articulo.each do |l|
      @dias = @dias + (l.fecha_hasta - l.fecha_desde).to_i
    end
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias - @dias
    render json:  @dias_disponibles
  end

  def buscar_articulo_dias_cargo_no_docente
    @licencia_cargo_no_docente = Licencium.where(cargo_no_docente_id: params[:id_cargos_no_docentes])
    @licencia_articulo = @licencia_cargo_no_docente.where(articulo_id: params[:id_articulo], vigente: "Finalizada")
    @dias=0
    @licencia_articulo.each do |l|
      @dias = @dias + (l.fecha_hasta - l.fecha_desde).to_i
    end
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias - @dias
    render json:  @dias_disponibles
  end

  private
    def set_licencium
      @licencium = Licencium.find(params[:id])
    end

    def licencium_params
      params.require(:licencium).permit(:altas_bajas_hora_id, :fecha_desde, :fecha_hasta, :articulo_id, :cargo_id, :cargo_no_docente_id, :vigente, :observaciones)
    end
end
