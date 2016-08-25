class EstablecimientoPlansController < InheritedResources::Base

  private

    def establecimiento_plan_params
      params.require(:establecimiento_plan).permit(:establecimiento_id, :plan_id)
    end
end

