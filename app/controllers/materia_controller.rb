class MateriaController < InheritedResources::Base
  before_action :set_materium, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: MateriaDatatable.new(view_context, { query: Materium.all }) }
    end
  end

  def show
    respond_with(@materium)
  end

  def new
    @materium = Materium.new
    respond_with(@materium)
  end

  def edit
  end

  def create
    @materium = Materium.new(materium_params)
    @materium.save
    respond_with(@materium)
  end

  def update
    @materium.update(materium_params)
    respond_with(@materium)
  end

  def destroy
    @materium.destroy
    respond_with(@materium)
  end

  private
    def set_materium
      @materium = Materium.find(params[:id])
    end

    def materium_params
      params.require(:materium).permit(:codigo, :descripcion)
    end
end

