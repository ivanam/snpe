class PlanillaIncompatibilidadsController < InheritedResources::Base
  load_and_authorize_resource

  def index
    respond_to do |format|
      format.html
      format.json { render json: PlanillaIncompatibilidadDatatable.new(view_context, { query: PlanillaIncompatibilidad.all }) }
    end
  end

  private

    def planilla_incompatibilidad_params
      params.require(:planilla_incompatibilidad).permit(:numero, :nota_ingreso, :apellido, :nombre, :dni, :fecha_nacimiento, :escuela_a, :escuela_b, :escuela_c, :escuela_d, :escuela_e, :observaciones_inc, :fecha1, :observaciones_suel, :text, :fecha2)
    end
end

