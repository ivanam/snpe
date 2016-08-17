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
    @altas = Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))
    
    @lic = Licencium.where(:cargo_id => @altas, :vigente => true)
    @a=[]
    @lic.each do |l|
      @a << l.c_id
     end 
    @altas2 = @altas.where.not(:id => @a)

    respond_to do |format|
      format.json { render json: CargosLicenciaPermitidaDatatable.new(view_context, { query: @altas2}) }
    end
  end

  def altas_bajas_horas_licencia_permitida2
    @altas = AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))
    
    @lic = Licencium.where(:altas_bajas_hora_id => @altas, :vigente => true)
    @a=[]
    @lic.each do |l|
      @a << l.ash_id
     end 
    @altas2 = @altas.where.not(:id => @a)
    respond_to do |format|
      format.json { render json: AltasBajasHoraLicenciaPermitidaDatatable.new(view_context, { query: @altas2}) }
    end
  end
  def licencia_dadas
    
    @altas = Licencium.where{(altas_bajas_hora_id == AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))) | (cargo_id == Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])))}
    #@altas << Licencium.where(:cargo_id => Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])))
    #Licencium.where.any_of({ altas_bajas_hora_id: AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))}, { cargo_id: Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])) })
    respond_to do |format|
      format.json { render json: LicenciaDatatable.new(view_context, { query: @altas}) }
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

  private
    def set_licencium
      @licencium = Licencium.find(params[:id])
    end

    def licencium_params
      params.require(:licencium).permit(:altas_bajas_hora_id, :altas_bajas_cargo_id, :fecha_desde, :fecha_hasta, :articulo_id)
    end
end
