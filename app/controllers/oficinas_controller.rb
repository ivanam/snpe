class OficinasController < ApplicationController
  before_action :set_oficina, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @oficinas = Oficina.all
    respond_with(@oficinas)
  end

  def show
    respond_with(@oficina)
  end

  def new
    @oficina = Oficina.new
    respond_with(@oficina)
  end

  def edit
  end

  def create
    @oficina = Oficina.new(oficina_params)
    @oficina.save
    respond_with(@oficina)
  end

  def update
    @oficina.update(oficina_params)
    respond_with(@oficina)
  end

  def destroy
    @oficina.destroy
    respond_with(@oficina)
  end

  private
    def set_oficina
      @oficina = Oficina.find(params[:id])
    end

    def oficina_params
      params.require(:oficina).permit(:nombre, :tipo)
    end
end
