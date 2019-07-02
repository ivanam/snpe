module ApplicationHelper
  def log_seperator
    return "***************************************************"
  end

  def log_error(message)
    logger.error(log_seperator);
    logger.error(controller_name + '.' + action_name + ":  " + message)
  end


  def establecimiento_actual
    return Establecimiento.find(session[:establecimiento])
  end

  def fusionchart
          # Chart rendering 
      @chart = Fusioncharts::Chart.new({
                width: "350",
                height: "250",
                type: "angulargauge",
                renderAt: "gaugeContainer",
        dataSource: {
            chart: {
                caption: "Horas",
                lowerLimit: "0",
                upperLimit: "100",
                showValue: "1",
                numberSuffix: "%",
                theme: "fusion",
                showToolTip: "0"
            },
            colorRange: {
                color: [{
                    minValue: "0",
                    maxValue: "50",
                    code: "#F2726F"
                }, {
                    minValue: "50",
                    maxValue: "75",
                    code: "#FFC533"
                }, {
                    minValue: "75",
                    maxValue: "100",
                    code: "#62B58F"
                }]
            },
            dials: {
                dial: [{
                    value: horas_porcentaje
                }]
            }
        } 

    })
      return @chart
  end

  def horas_porcentaje
    return  cantidad_registros_ok * 100 / cantidad_registros_total
  end

  def cantidad_registros_ok
    cantidad = 0
    @alta = AltasBajasHora.where(:establecimiento_id => Establecimiento.find(session[:establecimiento]).id).where.not(:estado => "LIC P/BAJ").where.not(:estado => "BAJ").where("fecha_baja is null")
    @alta.each do |a|
    if a.valid?
      if Plan.where(id: a.plan_id).first != nil and Materium.where(id: a.materium_id).first != nil
        if Despliegue.where(:plan_id => a.plan_id, :materium_id => a.materium_id).first != nil
            cantidad = cantidad + 1
        end
      end
    end
  end

    return cantidad
  end

  def cantidad_registros_mal
    cantidad = 0
    @alta = AltasBajasHora.where(:establecimiento_id => Establecimiento.find(session[:establecimiento]).id).where.not(:estado => "LIC P/BAJ").where.not(:estado => "BAJ").where("fecha_baja is null")
    @alta.each do |a|
        if !a.valid?
          cantidad = cantidad + 1
        else
          if Plan.where(id: a.plan_id).first != nil and Materium.where(id: a.materium_id).first != nil
            if Despliegue.where(:plan_id => a.plan_id, :materium_id => a.materium_id).first == nil
                cantidad = cantidad + 1
            end
          end
        end
    end
    return cantidad
  end

  def registros_mal

    registros =  []
    @alta = AltasBajasHora.where(:establecimiento_id => Establecimiento.find(session[:establecimiento]).id).where.not(:estado => "LIC P/BAJ").where.not(:estado => "BAJ").where("fecha_baja is null")
    @alta.each do |a|
        if !a.valid?
          registros << a
        else
          if Plan.where(id: a.plan_id).first != nil and Materium.where(id: a.materium_id).first != nil
            if Despliegue.where(:plan_id => a.plan_id, :materium_id => a.materium_id).first == nil

                a.errors.add(:status, "La materia no pertenece al plan")
                a.save
                registros << a
            end
          end
        end
    end
    return registros
  end

  def cantidad_registros_total
    cantidad = 0
    @alta = AltasBajasHora.where(:establecimiento_id => Establecimiento.find(session[:establecimiento]).id).where.not(:estado => "LIC P/BAJ").where.not(:estado => "BAJ").where("fecha_baja is null")
    cantidad = @alta.count
    return cantidad
  end

 def registros_sin_tit_int
    lista = []
    @alta = AltasBajasHora.where(:establecimiento_id => Establecimiento.find(session[:establecimiento]).id).where.not(:estado => "LIC P/BAJ").where.not(:estado => "BAJ").where("fecha_baja is null")
    @alta.each do |a|
      if Establecimiento.where(id: a.establecimiento_id).first.sede != 1
        if Plan.where(id: a.plan_id).first != nil and Materium.where(id: a.materium_id).first != nil
          if Despliegue.where(:plan_id => a.plan_id, :materium_id => a.materium_id).first != nil
            hora = AltasBajasHora.where(establecimiento_id: a.establecimiento_id, :plan_id => a.plan_id, :materium_id => a.materium_id, anio: a.anio, division: a.division, turno: a.turno)
            if hora.where(:situacion_revista => "1-1").first == nil and hora.where(:situacion_revista => "1-2").first == nil
              return lista << a
            end
          end
        end
      end
    end   
  end


   def establecimiento_region
    @establecimiento = Establecimiento.find(session[:establecimiento])
    @localidad = Localidad.find(@establecimiento.localidad_id)
    @region = Region.find(@localidad.region_id)
    return @region
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end