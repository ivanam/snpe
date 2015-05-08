module EstablecimientosHelper
  def establecimientos_permitidos
    if current_user.role? :sadmin then
      return Establecimiento.all
    else
      @establecimiento_ids = []
      current_user.establecimientos.each do |e|
        if e.peso == 0
          @establecimiento_ids << e.id
        else
          e.suborganizaciones_peso_cero.each do |sub0|
            @establecimiento_ids << sub0.id
          end
        end
      end
      return Establecimiento.where(id: @establecimiento_ids)
    end
  end
end
