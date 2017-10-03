class TipoHorasController < InheritedResources::Base

  def index
  	respond_to do |format|
      format.html
      format.json { render json: TipoHoraDatatable.new(view_context, { query: TipoHora.all }) }
    end
  end

  

  def show
  	@titulo = TipoHora.find(params[:id])
  end

  def new
    @TipoHora = TipoHora.new

  end

  def edit
    @TipoHora = TipoHora.find(params[:id])
  end

  def create
    @TipoHora = TipoHora.new(turno_params)

    respond_to do |format|
      if @TipoHora.save
        format.html { redirect_to @TipoHora, notice: 'Tipo Hora was successfully created.' }
        format.json { render json: @TipoHora, status: :created, location: @TipoHora }
      else
        format.html { render action: "new" }
        format.json { render json: @TipoHora.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @TipoHora.update(titulo_params)
    respond_with(@TipoHora)
  end

  def destroy
  	@TipoHora = TipoHora.find(params[:id])
    @TipoHora.destroy
    respond_to do |format|
      format.html { redirect_to TipoHora_url }
      format.json { head :no_content }
    end
  end

   private

    def tipo_hora_params
      params.require(:tipo_hora).permit(:nombre)
    end
end

