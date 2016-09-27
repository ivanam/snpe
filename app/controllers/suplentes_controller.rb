class SuplentesController < InheritedResources::Base

  private

    def suplente_params
      params.require(:suplente).permit(:altas_bajas_hora_id, :altas_bajas_hora_suplantada_id, :fecha_desde, :fecha_hasta, :observaciones, :estado)
    end
end

