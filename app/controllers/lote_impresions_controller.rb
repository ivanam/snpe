class LoteImpresionsController < ApplicationController
  before_action :set_lote_impresion, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: LoteImpresionDatatable.new(view_context, { query: lote_impresion_permitido }) }
    end
  end



  def show
    respond_with(@lote_impresion)
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'file_name',
        #:template => 'entradas/show.html.erb',
        :template => 'lote_impresions/pdf.html.erb',
        #:layout => 'application.html.erb',
        :layout => 'pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end

  def new
    @lote_impresion = LoteImpresion.new
    respond_with(@lote_impresion)
  end

  def edit
  end

  def create
    @lote_impresion = LoteImpresion.new(lote_impresion_params)
    @lote_impresion.save
    respond_with(@lote_impresion)
  end

  def update
    @lote_impresion.update(lote_impresion_params)
    respond_with(@lote_impresion)
  end

  def destroy
    @lote_impresion.destroy
    respond_with(@lote_impresion)
  end

  private
    def set_lote_impresion
      @lote_impresion = LoteImpresion.find(params[:id])
    end

    def lote_impresion_params
      params.require(:lote_impresion).permit(:fecha_impresion, :observaciones)
    end
end
