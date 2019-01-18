class ArticulosController < ApplicationController
  before_action :set_articulo, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: ArticuloDatatable.new(view_context, { query: Articulo.includes(:tipo_articulo) }) }
    end
  end

  def show
    respond_with(@articulo)
  end

  def new
    @articulo = Articulo.new
    respond_with(@articulo)
  end

  def edit
  end

  def create
    @articulo = Articulo.new(articulo_params)
    @articulo.save
    respond_with(@articulo)
  end

  def update
    @articulo.update(articulo_params)
    respond_with(@articulo)
  end

  def destroy
    @articulo.destroy
    respond_with(@articulo)
  end

  def permite_otro_organismo
    @articulo = Articulo.find(params[:id])
    render json: @articulo.permite_otro_organismo
  end

  private
    def set_articulo
      @articulo = Articulo.find(params[:id])
    end

    def articulo_params
      params.require(:articulo).permit(:codigo, :descripcion, :cantidad_maxima_dias, :tipo_articulo_id, :con_goce, :permite_otro_organismo)
    end
end
