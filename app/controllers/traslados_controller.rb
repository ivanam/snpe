class TrasladosController < InheritedResources::Base

  private

    def traslado_params
      params.require(:traslado).permit(:alta_baja_hora_id, :cargo_id, :cargo_no_docente_id, :fecha_cambio_oficina, :user_id)
    end
end

