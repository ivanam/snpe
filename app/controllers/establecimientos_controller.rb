class EstablecimientosController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /establecimientos
  # GET /establecimientos.json
  def index
    @establecimientos = Establecimiento.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @establecimientos }
    end
  end

  # GET /establecimientos/1
  # GET /establecimientos/1.json
  def show
    @establecimiento = Establecimiento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @establecimiento }
    end
  end

  # GET /establecimientos/new
  # GET /establecimientos/new.json
  def new
    @establecimiento = Establecimiento.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @establecimiento }
    end
  end

  # GET /establecimientos/1/edit
  def edit
    @establecimiento = Establecimiento.find(params[:id])
  end

  # POST /establecimientos
  # POST /establecimientos.json
  def create
    @establecimiento = Establecimiento.new(params[:establecimiento])

    respond_to do |format|
      if @establecimiento.save
        format.html { redirect_to @establecimiento, notice: 'Establecimiento was successfully created.' }
        format.json { render json: @establecimiento, status: :created, location: @establecimiento }
      else
        format.html { render action: "new" }
        format.json { render json: @establecimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /establecimientos/1
  # PUT /establecimientos/1.json
  def update
    @establecimiento = Establecimiento.find(params[:id])

    respond_to do |format|
      if @establecimiento.update_attributes(params[:establecimiento])
        format.html { redirect_to @establecimiento, notice: 'Establecimiento was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @establecimiento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /establecimientos/1
  # DELETE /establecimientos/1.json
  def destroy
    @establecimiento = Establecimiento.find(params[:id])
    @establecimiento.destroy

    respond_to do |format|
      format.html { redirect_to establecimientos_url }
      format.json { head :no_content }
    end
  end
end
