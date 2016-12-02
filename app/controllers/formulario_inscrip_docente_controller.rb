class FormularioInscripDocenteController < ApplicationController

  def index

    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'file_name',
        :page_height => 1, 
        :page_width => 1,
        :template => 'formulario_inscrip_docente/formulario_Inscripcion_Doc_pdf.html.erb',
        :page_size=>  'A4',
        :margin => {:top=> 0,
                   :bottom => 0,
                   :left => 0,
                   :right => 0},
        :layout => 'formulario_Inscripcion_Doc_pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end

  end

  def create
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'file_name',
        #:template => 'salidas/show.html.erb',
        :template => 'formulario_inscrip_docente/formulario_Inscripcion_Doc_pdf.html.erb',
        #:layout => 'application.html.erb',
        :layout => 'formulario_Inscripcion_Doc_pdf.html.erb',
        #:header => {:content => render_to_string({:template => 'layouts/header.html.erb',:layout   => 'pdf.html.erb'})},
        #:footer=> { :right => 'Page [page] of [topage]' },
        #:margin => { :top => 60, :bottom => 50},
        #:footer => { :html => { :template => 'layouts/footer.html.erb' } },
        #:footer => {:content => render_to_string({:template => 'layouts/footer.html.erb',:layout   => 'pdf.html.erb'})}
        #:footer => {:html => { :template => 'layouts/footer.html.erb', :layout   => 'pdf.html.erb',}}   
        :show_as_html => params[:debug].present?
      end
    end

  end


  def consulta_dni
    client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
    results = client.query("SELECT e.escuela, e.nombre, c.descripcion, p.apeynom, p.secuencia, a.cuit, p.fecha_ing from cargos as c , agentes_dni_cuit as a, paddoc as p , mec.escuelas as e where e.escuela=p.escuela and c.codigo = (IF(LENGTH(p.cargo_r)=1,CONCAT_WS('0', p.agrup_r, p.cargo_r),CONCAT_WS('', p.agrup_r, p.cargo_r))) and a.nume_docu=p.nume_docu and p.nume_docu = '"+params[:dni]+"' and p.planta_pre='1' and p.tipo_emp= '1' and (p.estado= 'ALT' or p.estado= 'LIC') order by p.secuencia desc limit 0,1")
    if results.first == nil
       results = client.query("SELECT e.escuela, e.nombre, c.descripcion, p.apeynom, p.secuencia, p.fecha_ing from cargos as c , paddoc as p , mec.escuelas as e where e.escuela=p.escuela and c.codigo = (IF(LENGTH(p.cargo_r)=1,CONCAT_WS('0', p.agrup_r, p.cargo_r),CONCAT_WS('', p.agrup_r, p.cargo_r))) and p.nume_docu = '"+params[:dni]+"' and p.planta_pre='1' and p.tipo_emp= '1' and (p.estado= 'ALT' or p.estado= 'LIC') order by p.secuencia desc limit 0,1")
    end
    respond_to do |format|
      format.json { render json: results.first}
    end      
  end

end



#SELECT c.codigo, e.escuela, e.nombre, c.descripcion, p.apeynom, p.secuencia, a.cuit, p.fecha_ing 
#from cargos as c , agentes_dni_cuit as a, paddoc as p , mec.escuelas as e 
#where e.escuela=p.escuela 
#and a.nume_docu=p.nume_docu 
#and p.nume_docu = '14580075' and c.codigo = (IF(LENGTH(p.cargo_r)=1,CONCAT_WS('0', p.agrup_r, p.cargo_r),CONCAT_WS('', p.agrup_r, p.cargo_r))) and p.planta_pre='1' and p.tipo_emp= '1' and (p.estado= 'ALT' or p.estado= 'LIC') order by p.secuencia desc limit 0,1



