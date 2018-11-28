class TrasladosController < ApplicationController

  load_and_authorize_resource
  respond_to :html

  def reporte
    
    mes = params[:mes] 
    anio = params[:anio]
    if mes == nil
      mes = Date.today.month.to_s
    end
    if anio == nil
      anio = Date.today.year.to_s
    end
    fecha_i = anio+"-"+mes+"-01"
    fecha_f = anio+"-"+mes+"-31"


    @traslados = Traslado.where("fecha_cambio_oficina >= '" + fecha_i + "'")

    respond_to do |format|
    format.pdf do
      render :pdf => 'reporte', 
      :template => 'traslados/reporte_pdf.html.erb',
      :layout => 'pdf.html.erb',
      :orientation => 'Landscape',# default Portrait
      :page_size => 'Legal', # default A4
      :show_as_html => params[:debug].present?
    end
    format.html 
    end 

  end


  private

    def traslado_params
      params.require(:traslado).permit(:alta_baja_hora_id, :cargo_id, :cargo_no_docente_id, :fecha_cambio_oficina, :user_id)
    end
end

