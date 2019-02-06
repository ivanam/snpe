class Ability
 
  include CanCan::Ability
 
  def initialize(user, establecimiento_id)
    user ||= User.new # guest user
    unless user.nil?
      if user.role? :sadmin
      	can :manage, :all
      end
      if true
        if (user.role? :escuela) || (user.role? :personal)
          can :cargos_bajas_efectivas, [Cargo]
          can :cargo_no_docentes_bajas_efectivas, [CargoNoDocente]
          can :modificacion, [Cargo]
          can :modificacion, [AltasBajasHora]
          can :modificacion, [CargoNoDocente]
          can :mostrar_edicion, [AltasBajasHora]
          can :mostrar_edicion2, [AltasBajasHora]
          can :guardar_edicion2, [AltasBajasHora]
          can :buscar_cuil, [AltasBajasHora]
          can :guardar_edicion, [AltasBajasHora]
  	      can :guardar_edicion2, [AltasBajasHora]
          can :mostrar_edicion, [Cargo]
          can :mostrar_edicion2, [Cargo]
          can :guardar_edicion2, [Cargo]
          can :buscar_cuil, [Cargo]
          can :guardar_edicion, [Cargo]
          can :guardar_edicion2, [Cargo]        
          can :mostrar_edicion, [CargoNoDocente]
          can :guardar_edicion2, [CargoNoDocente]
          can :mostrar_edicion2, [CargoNoDocente]
          can :guardar_edicion2, [CargoNoDocente]
          can :buscar_cuil, [CargoNoDocente]
          can :guardar_edicion, [CargoNoDocente]
          can :read, [Persona]
          can :edit, [Persona]
          can :update, [Persona]
          can :manage, [Licencium]
          can :read, [Licencium]
          can :manage, [Traslado]

        end

        if user.role? :personal
          can :cargos_bajas_efectivas, [Cargo]
          can :manage, [Cargo]
          can :cargo_no_docentes_bajas_efectivas, [CargoNoDocente]
          can :modificacion, [AltasBajasHora]
          can :modificacion, [Cargo]
          can :modificacion, [CargoNoDocente]
          can :manage, [Licencium]
          can :read, [Materium]
          can :read, [Plan]
          can :manage, [RegistrosParaSolucionar]
        end

        if user.role? :licencia
          can :cargos_bajas_efectivas, [Cargo]
          can :cargo_no_docentes_bajas_efectivas, [CargoNoDocente]
          can :modificacion, [AltasBajasHora]
          can :modificacion, [Cargo]
          can :modificacion, [CargoNoDocente]
          can :read, [Persona]
          can :edit, [Persona]
          can :update, [Persona]
          can :manage, [Licencium]
          can :read, [Licencium]
          can :read, [AltasBajasHora]
          can :read, [Cargo]
          can :read, [CargoNoDocente]

        end

        if user.role? :carga_planes
          can :create, [Plan]
          can :read, [Plan]
          can :create, [Despliegue]
          can :read, [Despliegue]
          can :create, [Materium]
          can :read, [Materium]      

        end

        if user.role? :adminJunta
          can :manage, [Concurso]
          can :manage, [Rubro]
          cannot :destroy, [Rubro]
          cannot :destroy, [Concurso]
        end

        if user.role? :junta
          can :show_nav, [Inscripcion]
          can :manage, [Inscripcion]
          can :manage, [Persona]
          can :manage, [Titulo]
          can :manage, [CargoInscripDoc]
          cannot :destroy, [CargoInscripDoc]
          can :manage, [Juntafuncion]
          cannot :destroy, [Juntafuncion]
          cannot :edit, [Juntafuncion]
          cannot :update, [Juntafuncion]
        end

        if user.role? :UserJunta
          
          can :read, Inscripcion, persona_id: user.get_persona.id
          can :update, Inscripcion, persona_id: user.get_persona.id
          can :create, Inscripcion, persona_id: user.get_persona.id
          can :edit, Inscripcion, persona_id: user.get_persona.id
          cannot :index, Inscripcion
          
          can :read, Persona, :id => user.get_persona.id
          can :edit, Persona, :id => user.get_persona.id
          can :update, Persona, :id => user.get_persona.id
        end

        if user.role? :incompatibilidad
          can :manage, [PlanillaIncompatibilidad]
        end

        user.roles.each do |ro|
          can do |action, subject_class, subject|
            ro.permissions.find_all_by_action([aliases_for_action(action), :manage].flatten).any? do |permission|
              if permission.action != "manage" then
                permission.subject_class == subject_class.to_s && permission.action == action.to_s
              else
                true
              end
            end
          end 
        end
        #------------------------------- Fin permisos -------------------------------------
      end
    end
  end
end
