class DesplieguesController < InheritedResources::Base

  private

    def despliegue_params
      params.require(:despliegue).permit(:anio, :plan_id, :materia_id, :carga_horaria)
    end
end

