class ReportesController < ApplicationController
  before_filter :authenticate_user!

  autocomplete :persona, :apeynom, :full => false, :extra_data => [:apeynom, :nro_documento], :display_value => :to_s
  before_action :set_licencium, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def licencias_diario
 
    filename = "reportes_licencias_diario.xls"
    respond_to do |format|
      format.html
      format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" }
      format.pdf do
        render :pdf => 'file_name',
        :template => 'reportes/matriculas_total_pdf.html.erb',
        :layout => 'pdf.html.erb',
        :page_size=>  'A4',
        :margin => {:top=> 0,
                   :bottom => 0,
                   :left => 0,
                   :right => 0}
      end
    end
  end



  def get_autocomplete_items
    
    render json: Persona.where('nro_documento like "%' + params[:term] + '%" or apeynom like "%' + params[:term] + '%"').pluck(:apeynom).to_json
  end

  def historial_agente
  end

  def cargos
    @dni=params[:dni]
    id_persona = Persona.where(:nro_documento => @dni).first
    @cargos = Cargo.where(:persona_id => id_persona).where.not(:estado => "BAJ").where.not(estado: "LIC P/BAJ")
    respond_to do |format|
      format.json { render json: CargosActivosDatatable.new(view_context, { query: @cargos}) }
    end
  end

  def horas
    @dni=params[:dni]
    id_persona = Persona.where(:nro_documento => @dni).first
    @horas = AltasBajasHora.where(:persona_id => id_persona).where.not(:estado => "BAJ").where.not(estado: "LIC P/BAJ")

    respond_to do |format|
      format.json { render json: HorasActivasDatatable.new(view_context, { query: @horas}) }
    end
  end

  def auxiliares
    @dni=params[:dni]
    id_persona = Persona.where(:nro_documento => @dni).first
    @auxiliares = CargoNoDocente.where(:persona_id => id_persona).where.not(:estado => "BAJ").where.not(estado: "LIC P/BAJ")

    respond_to do |format|
      format.json { render json: AuxiliaresActivosDatatable.new(view_context, { query: @auxiliares}) }
    end
  end


  
end