class MotivoBajasController < InheritedResources::Base

before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /turno
  # GET /turno.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: MotivoBajaDatatable.new(view_context, { query: MotivoBaja.all }) }
    end
  end

  # GET /turno/1
  # GET /turno/1.json
  def show
    @motivobaja = MotivoBaja.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @motivobaja }
    end
  end

  # GET /turno/new
  # GET /turno/new.json
  def new
    @motivobaja = MotivoBaja.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @motivobaja }
    end
  end

  # GET /turno/1/edit
  def edit
    @motivobaja = MotivoBaja.find(params[:id])
  end

  # POST /turno
  # POST /turno.json
  def create
    @motivobaja = MotivoBaja.new(motivo_baja_params)

    respond_to do |format|
      if @motivobaja.save
        format.html { redirect_to @motivobaja, notice: 'Motivo Baja was successfully created.' }
        format.json { render json: @motivobaja, status: :created, location: @motivobaja }
      else
        format.html { render action: "new" }
        format.json { render json: @motivobaja.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /turno/1
  # PUT /turno/1.json
  def update
    @motivobaja = MotivoBaja.find(params[:id])

    respond_to do |format|
      if @motivobaja.update(motivo_baja_params)
        format.html { redirect_to @motivobaja, notice: 'Motivo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @motivobaja.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turno/1
  # DELETE /turno/1.json
  def destroy
  	 @motivobaja = MotivoBaja.find(params[:id])
     @motivobaja.destroy
     respond_with(@motivobaja)
  end

  private
    def set_motivo
      @motivobaja = MotivoBaja.find(params[:id])
    end

    def motivo_baja_params
      params.require(:motivo_baja).permit(:nro_motivo, :motivo)
    end
end

