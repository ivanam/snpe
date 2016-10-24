class TurnosController < InheritedResources::Base
  before_filter :authenticate_user!
  load_and_authorize_resource
  # GET /turno
  # GET /turno.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: TurnoDatatable.new(view_context, { query: Turno.all }) }
    end
  end

  # GET /turno/1
  # GET /turno/1.json
  def show
    @turno = Turno.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @turno }
    end
  end

  # GET /turno/new
  # GET /turno/new.json
  def new
    @turno = Turno.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @turno }
    end
  end

  # GET /turno/1/edit
  def edit
    @turno = Turno.find(params[:id])
  end

  # POST /turno
  # POST /turno.json
  def create
    @turno = Turno.new(turno_params)

    respond_to do |format|
      if @turno.save
        format.html { redirect_to @turno, notice: 'Turno was successfully created.' }
        format.json { render json: @turno, status: :created, location: @turno }
      else
        format.html { render action: "new" }
        format.json { render json: @turno.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /turno/1
  # PUT /turno/1.json
  def update
    @turno = Turno.find(params[:id])

    respond_to do |format|
      if @turno.update(turno_params)
        format.html { redirect_to @turno, notice: 'Turno was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @turno.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /turno/1
  # DELETE /turno/1.json
  def destroy
    @turno = Turno.find(params[:id])
    @turno.destroy

    respond_to do |format|
      format.html { redirect_to turno_url }
      format.json { head :no_content }
    end
  end

  private
    def set_turno
      @turno = Turno.find(params[:id])
    end

    def turno_params
      params.require(:turno).permit(:descripcion)
    end
end

