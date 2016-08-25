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

  def cargos_licencia_permitida
    @cargos_persona = Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))
    @licencias_cargo = Licencium.where(:cargo_id => @cargos_persona, :vigente => true).map(&:cargo_id)
    @cargos_persona_permitida = @cargos_persona.where.not(:id => @licencia_cargo)

    respond_to do |format|
      format.json { render json: CargosLicenciaPermitidaDatatable.new(view_context, { query: @cargos_persona_permitida}) }
    end
  end

  def altas_bajas_horas_licencia_permitida
    @horas_persona = AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))
    @licencia_horas = Licencium.where(:altas_bajas_hora_id => @horas_persona, :vigente => true).map(&:altas_bajas_hora_id)
    @horas_persona_permitida = @horas_persona.where.not(:id => @licencia_horas)
    respond_to do |format|
      format.json { render json: AltasBajasHoraLicenciaPermitidaDatatable.new(view_context, { query: @horas_persona_permitida}) }
    end
  end

  def licencia_dadas
    
    #@altas = Licencium.where{(altas_bajas_hora_id == AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))) | (cargo_id == Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])))}
    @licencia_cargo=Licencium.where(:cargo_id => Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))).map(&:id)
    @licencia_horas=Licencium.where(:altas_bajas_hora_id => AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))).map(&:id)
    @licencia_cargo.each do |l|
      @licencia_horas.push(l)
    end 

     @licencias=Licencium.where(:id => @licencia_horas)
    
    respond_to do |format|
      format.json { render json: LicenciaDatatable.new(view_context, { query: @licencias}) }
    end
  end 

  

  def guardar_licencia_horas
    
    @licencia = Licencium.create(altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: true)
    
    @licencia.save
    render json: 0
  end 
  def guardar_licencia_cargos
    
    @licencia = Licencium.create(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: true)
    
    @licencia.save
    render json: 0
  end 
  def guardar_licencia_final
    
    @licencia = Licencium.where(id: params[:id_lic]).first
    
    @licencia.update(:vigente => false)
    render json: 0
  end 

  def buscar_articulo_dias

    @licencia_hora = Licencium.where(altas_bajas_hora_id: params[:id_horas])
    @licencia_articulo = @licencia_hora.where(articulo_id: params[:id_articulo])
    @dias=0
    @licencia_hora.each do |l|
      @dias = @dias + (l.fecha_desde - l.fecha_hasta).to_i
    end
    
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias - @dias
    render json:  @dias_disponibles
  end

  private
    def set_licencium
      @licencium = Licencium.find(params[:id])
    end

    def licencium_params
      params.require(:licencium).permit(:altas_bajas_hora_id, :altas_bajas_cargo_id, :fecha_desde, :fecha_hasta, :articulo_id)
    end
end
