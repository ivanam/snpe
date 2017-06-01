class NivelsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource

  respond_to :html

  def index
    @nivels = Nivel.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @nivels }
    end
  end

  # GET /nivels/1
  # GET /nivels/1.json
  def show
    @nivel = Nivel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @nivel }
    end
  end

  # GET /nivels/new
  # GET /nivels/new.json
  def new
    @nivel = Nivel.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @nivel }
    end
  end

  # GET /nivels/1/edit
  def edit
    @nivel = Nivel.find(params[:id])
  end

  def create
    @nivel = Nivel.new(nivel_params)
    @nivel.save
    respond_with(@nivel)
  end

  def update
    @nivel.update(nivel_params)
    respond_with(@nivel)
  end

  # DELETE /nivels/1
  # DELETE /nivels/1.json
  def destroy
    @nivel = Nivel.find(params[:id])
    @nivel.destroy

    respond_to do |format|
      format.html { redirect_to nivels_url }
      format.json { head :no_content }
    end
  end

  private
    def set_nivel
      @nivel = Nivel.find(params[:id])
    end

    def nivel_params
      params.require(:nivel).permit(:nombre)
  end

end
