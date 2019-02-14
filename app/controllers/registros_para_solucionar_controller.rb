class RegistrosParaSolucionarController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource


  def reporte
    if params[:anio] != nil and params[:anio] != "" and params[:mes] != nil and params[:mes] != ""
      mes = params[:mes].to_i
      anio = params[:anio].to_i
      @registros = RegistrosParaSolucionar.where(:anio_liq => anio, :mes_liq => mes)
    else
      @registros = RegistrosParaSolucionar.where(:mes_liq => (Date.current.month - 1) , :anio_liq => 2018
      )
    end

    respond_to do |format|
      format.pdf do
        render :pdf => 'reporte_pdf', 
        :template => 'registros_para_solucionar/reporte_pdf.html.erb',
        :layout => 'pdf.html.erb',
        :orientation => 'Landscape',# default Portrait
        :page_size => 'Legal', # default A4
        :show_as_html => params[:debug].present?
      end
      format.html
      format.json { render json: RegistrosParaSolucionarDatatable.new(view_context, { query: @registros }) }
    end
  end

  def chequear_registro
      
    @registro = RegistrosParaSolucionar.where(:id => params[:id]).first
    @registro.update!(chequeada: true, user_chequeada_id: current_user.id, fecha_chequeada: DateTime.now)
    render json: @registro
  end


  private
    def registros_para_solucionar_params
      params.require(:registros_para_solucionar).permit(:mes_liq, :anio_liq, :horas_registro, :cargos_registro, :auxiliar_registro, :establecimiento_id, :persona_id, :secuencia, :fecha_alta, :fecha_baja, :situacion_revista, :horas, :ciclo_carrera, :anio, :division, :turno, :codificacion, :estado, :materium_id, :plan_id, :cargo)
    end
end

