class ReportesController < ApplicationController
  before_filter :authenticate_user!
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

  
end