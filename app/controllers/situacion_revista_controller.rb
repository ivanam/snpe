class SituacionRevistaController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /situacion_revista
  # GET /situacion_revista.json
  def index
    @situacion_revista = SituacionRevistum.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @situacion_revista }
    end
  end

  # GET /situacion_revista/1
  # GET /situacion_revista/1.json
  def show
    @situacion_revistum = SituacionRevistum.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @situacion_revistum }
    end
  end

  # GET /situacion_revista/new
  # GET /situacion_revista/new.json
  def new
    @situacion_revistum = SituacionRevistum.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @situacion_revistum }
    end
  end

  # GET /situacion_revista/1/edit
  def edit
    @situacion_revistum = SituacionRevistum.find(params[:id])
  end

  # POST /situacion_revista
  # POST /situacion_revista.json
  def create
    @situacion_revistum = SituacionRevistum.new(params[:situacion_revistum])

    respond_to do |format|
      if @situacion_revistum.save
        format.html { redirect_to @situacion_revistum, notice: 'Situacion revistum was successfully created.' }
        format.json { render json: @situacion_revistum, status: :created, location: @situacion_revistum }
      else
        format.html { render action: "new" }
        format.json { render json: @situacion_revistum.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /situacion_revista/1
  # PUT /situacion_revista/1.json
  def update
    @situacion_revistum = SituacionRevistum.find(params[:id])

    respond_to do |format|
      if @situacion_revistum.update_attributes(params[:situacion_revistum])
        format.html { redirect_to @situacion_revistum, notice: 'Situacion revistum was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @situacion_revistum.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /situacion_revista/1
  # DELETE /situacion_revista/1.json
  def destroy
    @situacion_revistum = SituacionRevistum.find(params[:id])
    @situacion_revistum.destroy

    respond_to do |format|
      format.html { redirect_to situacion_revista_url }
      format.json { head :no_content }
    end
  end
end
