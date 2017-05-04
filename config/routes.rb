ProyectoBase::Application.routes.draw do
  
  

   scope '/soft/snpe' do

    ActiveAdmin.routes(self)
  
    post "util/buscar_persona/:dni", to: 'util#buscar_persona'

    post "util/buscar_persona_por_id/:id", to: 'util#buscar_persona_por_id'

    post "util/buscar_estados_altas_bajas_hora/:id", to: 'util#buscar_estados_altas_bajas_hora'    

    post "util/buscar_estados_cargo/:id", to: 'util#buscar_estados_cargo'  

    post "util/buscar_estados_cargo_no_docente/:id", to: 'util#buscar_estados_cargo_no_docente'  

    get "util/buscar_materias_plan/:plan_id/:anio", to: 'util#buscar_materias_plan'

    get "util/buscar_carga_horaria_materia/:materium_id/:plan_id/:anio", to: 'util#buscar_carga_horaria_materia'

    post "/formulario_inscrip_docente.pdf", to: 'formulario_inscrip_docente#index'

    post "/formulario_Inscripcion_Doc_.pdf", to: 'formulario_inscrip_docente#index'

    post "/formulario_inscrip_docente/formulario_Inscripcion_Doc_pdf", to: 'formulario_inscrip_docente#formulario_Inscripcion_Doc_pdf'

    get "/inscripcions/index", to: 'inscripcions#index'

    get "inscripcions/cv/:id", to: "inscripcions#cv", as: :cv

    get "buscar_cv_persona/", to: 'inscripcions#buscar_cv_persona'

    get "inscripcions/buscar_persona/:dni", to: 'inscripcions#buscar_persona'

    get "inscripcions/new", to: "inscripcions#new", as: :new_inscripcions

    get "cargo_inscrip_docs/new", to: "cargo_inscrip_docs#new", as: :new_cargo_inscrip_docs

    get "/cargo_inscrip_docs/index", to: 'cargo_inscrip_docs#index'

    get "/titulos/index", to: 'titulos#index'

    get "titulos/new", to: "titulos#new", as: :new_titulos 

    get "/titulo_personas/index", to: 'titulo_personas#index'   

    resources :articulos

    resources :funcions

    resources :cargosnds

    resources :turnos

    resources :suplentes

    resources :primaria_cargos

    resources :ambitos

    resources :primaria_cargos

    resources :despliegues

    resources :establecimiento_plans

    resources :plans

    resources :materia


    resources :lugar_pagos

    resources :formulario_inscrip_docente

    resources :rubros

    resources :inscripcions

    resources :funcions

    resources :suplentes

    resources :titulo_personas

    resources :titulos

    resources :cargo_inscrip_docs


    #---------------------------------------------------------------------------------------------------------------------------------------
    
    resources :empresas

    resources :asistencia

    #Páginas de asistencia
    get "asistencias/index/", to: "asistencia#index", as: :asistencia_index

    get "asistencias/index_cargo/", to: "asistencia#index_cargo", as: :asistencia_index_cargo

    get "asistencias/index_cargo_no_docente/", to: "asistencia#index_cargo_no_docente", as: :asistencia_index_cargo_no_docente

    get "asistencias/index_novedades_alta_baja_hora/", to: "asistencia#index_novedades_alta_baja_hora", as: :asistencia_index_novedades_alta_baja_hora
    
    get "asistencias/index_novedades_cargo/", to: "asistencia#index_novedades_cargo", as: :asistencia_index_novedades_cargo

    get "asistencias/index_novedades_cargo_no_docente/", to: "asistencia#index_novedades_cargo_no_docente", as: :asistencia_index_novedades_cargo_no_docente

    #Datatables

    get "asistencias/personal_activo/", to: "asistencia#index_personal_activo", as: :asistencia_index_personal_activo

    get "asistencias/personal_cargo/", to: "asistencia#personal_cargo", as: :asistencia_personal_cargo

    get "asistencias/personal_cargo_no_docente/", to: "asistencia#personal_cargo_no_docente", as: :asistencia_personal_cargo_no_docente

    get "asistencias/novedades_hora/", to: "asistencia#novedades_hora", as: :asistencia_novedades_hora

    get "asistencias/novedades_cargo/", to: "asistencia#novedades_cargo", as: :asistencia_novedades_cargo

    get "asistencias/novedades_cargo_no_docente/", to: "asistencia#novedades_cargo_no_docente", as: :asistencia_novedades_cargo_no_docente


    #Otras funciones

    get "asistencias/altas_bajas_horas_informar", to: "asistencia#altas_bajas_horas_informar", as: :altas_bajas_horas_informar_asistencia

    get "asistencias/cargos_informar", to: "asistencia#cargos_informar", as: :cargos_informar_asistencia

    get "asistencias/cargo_no_docentes_informar", to: "asistencia#cargo_no_docentes_informar", as: :cargo_no_docentes_informar_asistencia

    get "asistencias/cargos_imprimir", to: "asistencias#cargos_imprimir", as: :cargos_imprimir_asistencia

    put "asistencias/editar_asistencia/:id", to: "asistencia#editar_asistencia", as: :asistencia_editar_asistencia

    put "asistencias/editar_asistencia_cargo/:id", to: "asistencia#editar_asistencia_cargo", as: :asistencia_editar_asistencia_cargo

    put "asistencias/editar_asistencia_cargo_no_docente/:id", to: "asistencia#editar_asistencia_cargo_no_docente", as: :asistencia_editar_asistencia_cargo_no_docente

    #---------------------------------------------------------------------------------------------------------------------------------------

    resources :oficinas    

    get "altas_bajas_horas/bajas/", to: "altas_bajas_horas#index_bajas", as: :altas_bajas_horas_index_bajas
 
    put "altas_bajas_horas/editar_campos/", to: "altas_bajas_horas#editar_campos", as: :altas_bajas_horas_editar_campos

    
    get "altas_bajas_horas/modificacion/", to: "altas_bajas_horas#modificacion", as: :altas_bajas_horas_modificacion

    get "altas_bajas_horas/notificadas/", to: "altas_bajas_horas#index_notificadas", as: :altas_bajas_horas_index_notificadas    

    put "altas_bajas_horas/dar_baja/:id", to: "altas_bajas_horas#dar_baja", as: :altas_bajas_horas_dar_baja

    get "altas_bajas_horas/bajas_efectivas/", to: "altas_bajas_horas#index_bajas_efectivas", as: :altas_bajas_horas_index_bajas_efectivas

    get "altas_bajas_horas/importar/", to: "altas_bajas_horas#importar", as: :altas_bajas_horas_importar

    get "altas_bajas_horas/importar_recibos/", to: "altas_bajas_horas#importar_recibos", as: :altas_bajas_horas_importar_recibos

    get "altas_bajas_horas/personal_activo/", to: "altas_bajas_horas#index_personal_activo", as: :altas_bajas_horas_index_personal_activo

    post "altas_bajas_horas/buscar_alta/:id_alta/", to: "altas_bajas_horas#buscar_alta", as: :altas_bajas_horas_buscar_alta

    get "altas_bajas_horas/:id/editar_alta/", to: "altas_bajas_horas#editar_alta", as: :altas_bajas_horas_editar_alta

    get "altas_bajas_horas/:id/modificar/", to: "altas_bajas_horas#modificar", as: :altas_bajas_horas_modificar

     get "altas_bajas_horas/obtener_id/:id", to: "altas_bajas_horas#obtener_id", as: :altas_bajas_horas_obtener_id


    patch "altas_bajas_horas/guardar_edicion/:id", to: "altas_bajas_horas#guardar_edicion", as: :altas_bajas_horas_guardar_edicion

    post "altas_bajas_horas/guardar_edicion2", to: "altas_bajas_horas#guardar_edicion2", as: :altas_bajas_horas_guardar_edicion2

    get "altas_bajas_horas/notificar/:id", to: "altas_bajas_horas#notificar", as: :altas_bajas_horas_notificar

    put "altas_bajas_horas/cancelar/:id", to: "altas_bajas_horas#cancelar", as: :altas_bajas_horas_cancelar

    get "altas_bajas_horas/chequear/:id", to: "altas_bajas_horas#chequear", as: :altas_bajas_horas_chequear

    get "altas_bajas_horas/imprimir/:id", to: "altas_bajas_horas#imprimir", as: :altas_bajas_horas_imprimir

    get "altas_bajas_horas/notificar_baja/:id", to: "altas_bajas_horas#notificar_baja", as: :altas_bajas_horas_notificar_baja

    get "altas_bajas_horas/cancelar_baja/:id", to: "altas_bajas_horas#cancelar_baja", as: :altas_bajas_horas_cancelar_baja

    get "altas_bajas_horas/mostrar_edicion/:id", to: "altas_bajas_horas#mostrar_edicion", as: :altas_bajas_horas_mostrar_edicion

    get "altas_bajas_horas/mostrar_edicion2/:id", to: "altas_bajas_horas#mostrar_edicion2", as: :altas_bajas_horas_mostrar_edicion2

    get "altas_bajas_horas/buscar_cuil/:id", to: "altas_bajas_horas#buscar_cuil", as: :altas_bajas_horas_buscar_cuil

    get "altas_bajas_horas/chequear_baja/:id", to: "altas_bajas_horas#chequear_baja", as: :altas_bajas_horas_chequear_baja

    get "altas_bajas_horas/imprimir_baja/:id", to: "altas_bajas_horas#imprimir_baja", as: :altas_bajas_horas_imprimir_baja

    get "altas_bajas_horas/novedades/", to: "altas_bajas_horas#index_novedades", as: :horas_index_novedades

    get "altas_bajas_horas/cola-impresion/", to: "altas_bajas_horas#index_cola_impresion", as: :horas_index_cola_impresion

    get "altas_bajas_horas/imprimir-cola/", to: "altas_bajas_horas#imprimir_cola", as: :horas_imprimir_cola

    get "altas_bajas_horas/cancelar-cola/", to: "altas_bajas_horas#cancelar_cola", as: :horas_cancelar_cola

    get "altas_bajas_horas/cargo_por_materia/:materium_id/:plan_id/:anio/:division", to: 'altas_bajas_horas#cargo_por_materia', as: :altas_bajas_horas_cargo_por_materia

   #get "altas_bajas_horas/modificar", to: 'altas_bajas_horas#modificar', as: :modificar_hs


    resources :altas_bajas_horas

    #--------------------------- Bloque de Cargos -------------------------------------------------------------------------------------
    resources :cargos

        
    get "cargo/bajas/", to: "cargos#index_bajas", as: :cargos_index_bajas

    get "cargos/:id", to: "cargos#show", as: :cargos_show

    put "cargo/editar_campos/", to: "cargos#editar_campos", as: :cargo_editar_campos
    
    get "cargo/modificacion/", to: "cargos#modificacion", as: :cargos_modificacion

    get "cargo/buscar_cuil/:id", to: "cargos#buscar_cuil", as: :cargos_buscar_cuil
    
    get "cargo/cancelar-cola/", to: "cargos#cancelar_cola", as: :cargo_cancelar_cola

    get "cargo/:id/editar_alta/", to: "cargos#editar_alta", as: :cargo_editar_alta

    get "cargo/mostrar_edicion/:id", to: "cargos#mostrar_edicion", as: :cargos_mostrar_edicion

    get "cargo/mostrar_edicion2/:id", to: "cargos#mostrar_edicion2", as: :cargos_mostrar_edicion2

    post "cargo/guardar_edicion2", to: "cargos#guardar_edicion2", as: :cargos_guardar_edicion2

    patch "cargo/guardar_edicion/:id", to: "cargos#guardar_edicion", as: :cargo_guardar_edicion

    get "cargo/imprimir-cola/", to: "cargos#imprimir_cola", as: :cargos_imprimir_cola

    get "cargo/novedades/", to: "cargos#index_novedades", as: :cargos_index_novedades

    #Cambios de estado
    
    put "cargo/cancelar/:id", to: "cargos#cancelar", as: :cargo_cancelar

    get "cargo/cancelar_baja/:id", to: "cargos#cancelar_baja", as: :cargo_cancelar_baja

    get "cargo/chequear/:id", to: "cargos#chequear", as: :cargo_chequear

    get "cargo/chequear_baja/:id", to: "cargos#chequear_baja", as: :cargo_chequear_baja

    put "cargo/dar_baja/:id", to: "cargos#dar_baja", as: :cargo_dar_baja

    get "cargo/imprimir/:id", to: "cargos#imprimir", as: :cargo_imprimir

    get "cargo/notificar/:id", to: "cargos#notificar", as: :cargo_notificar

    #Datatables
    
    get "cargo/cargos_bajas/", to: "cargos#cargos_bajas", as: :cargos_bajas

    get "cargo/cargos_bajas_efectivas/", to: "cargos#cargos_bajas_efectivas", as: :cargos_bajas_efectivas

    get "cargo/cola-impresion/", to: "cargos#cola_impresion", as: :cargos_cola_impresion

    get "cargo/cargos_notificados/", to: "cargos#cargos_notificados", as: :cargos_notificados

    get "cargo/cargos_novedades/", to: "cargos#cargos_novedades", as: :cargos_novedades

    get "cargo/cargos_nuevos/", to: "cargos#cargos_nuevos", as: :cargos_nuevos

    get "cargo/persona_por_cargo/:cargo_id", to: 'cargo#persona_por_cargo', as: :persona_por_cargo

    #----------------------------------------------------------------------------------------------------------------------------------

    resources :cargo_no_docentes

    get "cargo_no_docentes/:id", to: "cargo_no_docentes#show", as: :cargo_no_docentes_show
    
    get "cargo_no_docente/modificacion/", to: "cargo_no_docentes#modificacion", as: :cargo_no_docentes_modificacion

    get "cargo_no_docente/mostrar_edicion/:id", to: "cargo_no_docentes#mostrar_edicion", as: :cargo_no_docentes_mostrar_edicion

    get "cargo_no_docente/mostrar_edicion2/:id", to: "cargo_no_docentes#mostrar_edicion2", as: :cargo_no_docentes_mostrar_edicion2

    post "cargo_no_docente/guardar_edicion2", to: "cargo_no_docentes#guardar_edicion2", as: :cargo_no_docentes_guardar_edicion2

    get "cargo_no_docente/buscar_cuil/:id", to: "cargo_no_docentes#buscar_cuil", as: :cargo_no_docentes_buscar_cuil

    get "cargo_no_docente/cancelar-cola/", to: "cargo_no_docentes#cancelar_cola", as: :cargo_no_docentes_cancelar_cola

    get "cargo_no_docente/bajas/", to: "cargo_no_docentes#index_bajas", as: :cargo_no_docentes_index_bajas

    get "cargo_no_docente/novedades/", to: "cargo_no_docentes#index_novedades", as: :cargo_no_docentes_index_novedades

    get "cargo_no_docente/cargo_no_docentes_novedades/", to: "cargo_no_docentes#cargo_no_docentes_novedades", as: :cargo_no_docentes_novedades

    get "cargo_no_docente/cargo_no_docentes_nuevos/", to: "cargo_no_docentes#cargo_no_docentes_nuevos", as: :cargo_no_docentes_nuevos

    get "cargo_no_docente/cola-impresion/", to: "cargo_no_docentes#cola_impresion", as: :cargo_no_docentes_cola_impresion

    get "cargo_no_docente/imprimir-cola/", to: "cargo_no_docentes#imprimir_cola", as: :cargo_no_docentes_imprimir_cola

    get "cargo_no_docente/imprimir/:id", to: "cargo_no_docentes#imprimir", as: :cargo_no_docentes_imprimir
    
    get "cargo_no_docente/notificar/:id", to: "cargo_no_docentes#notificar", as: :cargo_no_docentes_notificar

    get "cargo_no_docente/cargo_no_docentes_notificados/", to: "cargo_no_docentes#cargo_no_docentes_notificados", as: :cargo_no_docentes_notificados

    get "cargo_no_docente/:id/editar_alta/", to: "cargo_no_docentes#editar_alta", as: :cargo_no_docentes_editar_alta

    patch "cargo_no_docente/guardar_edicion/:id", to: "cargo_no_docentes#guardar_edicion", as: :cargo_no_docentes_guardar_edicion

    put "cargo_no_docente/cancelar/:id", to: "cargo_no_docentes#cancelar", as: :cargo_no_docentes_cancelar

    get "cargo_no_docente/chequear/:id", to: "cargo_no_docentes#chequear", as: :cargo_no_docentes_chequear

    get "cargo_no_docente/cargo_no_docentes_bajas/", to: "cargo_no_docentes#cargo_no_docentes_bajas", as: :cargo_no_docentes_bajas

    get "cargo_no_docente/cargo_no_docentes_bajas_efectivas/", to: "cargo_no_docentes#cargo_no_docentes_bajas_efectivas", as: :cargo_no_docentes_bajas_efectivas

    put "cargo_no_docente/dar_baja/:id", to: "cargo_no_docentes#dar_baja", as: :cargo_no_docentes_dar_baja

    get "cargo_no_docente/cancelar_baja/:id", to: "cargo_no_docentes#cancelar_baja", as: :cargo_no_docente_cancelar_baja

    get "cargo_no_docente/chequear_baja/:id", to: "cargo_no_docentes#chequear_baja", as: :cargo_no_docente_chequear_baja

    resources :establecimientos

    get "establecimientos_de_usuario", to: "establecimientos#establecimientos_de_usuario", as: :establecimientos_de_usuario

    get "establecimiento/seleccionar/:id", to: "establecimientos#seleccionar", as: :establecimiento_seleccionar

    resources :estados

    resources :oficinas

    get "pagina_inicio/index"

    resources :personas

    #-------------------------------------------------------------------------------

    resources :licencia

    get "util/buscar_hora/:dni", to: 'util#buscar_hora'
    post "util/buscar_hora/:dni", to: 'util#buscar_hora'
    get 'licencia/altas_bajas_horas_licencia_permitida/:dni', to: 'licencia#altas_bajas_horas_licencia_permitida', as: :altas_bajas_horas_licencia_permitida
    get 'licencia/cargos_licencia_permitida/:dni', to: 'licencia#cargos_licencia_permitida', as: :cargos_licencia_permitida
    get 'licencia/licencia_dadas/:dni', to: 'licencia#licencia_dadas', as: :licencia_dadas
    get 'licencia/buscar_articulo_dias_hora/:id_articulo/:id_horas', to: 'licencia#buscar_articulo_dias_hora', as: :buscar_articulo_dias_hora
    get 'licencia/buscar_articulo_dias_cargo/:id_articulo/:id_cargos', to: 'licencia#buscar_articulo_dias_cargo', as: :buscar_articulo_dias_cargo
    get 'licencia/buscar_articulo_dias_cargo_no_docente/:id_articulo/:id_cargos_no_docentes', to: 'licencia#buscar_articulo_dias_cargo_no_docente', as: :buscar_articulo_dias_cargo_no_docente
    get 'licencias/listado_licencias', to: 'licencia#listado_licencias', as: :listado_licencias
    get 'licencias/cargos_no_docentes_licencia_permitida', to: 'licencia#cargos_no_docentes_licencia_permitida', as: :cargos_no_docentes_licencia_permitida

    
    
    post "licencia/guardar_licencia_horas/:id_horas/:fecha_inicio/:fecha_fin/:articulo", to: "licencia#guardar_licencia_horas", as: :guardar_licencia_horas
    post "licencia/guardar_licencia_cargos/:id_cargos/:fecha_inicio/:fecha_fin/:articulo", to: "licencia#guardar_licencia_cargos", as: :guardar_licencia_cargos
    post "licencia/guardar_licencia_cargos_no_docentes/:id_cargos_no_docentes/:fecha_inicio/:fecha_fin/:articulo", to: "licencia#guardar_licencia_cargos_no_docentes", as: :guardar_licencia_cargos_no_docentes
    post "licencia/guardar_licencia_final/:id_lic/:fecha_inicio/:fecha_fin/:por_baja", to: "licencia#guardar_licencia_final", as: :guardar_licencia_final
    post "licencia/cancelar_licencia/:id_lic", to: "licencia#cancelar_licencia", as: :cancelar_licencia
    
    #----------------Reportes--------------------------------------------------------
   
    get "reportes/index"

    get "reportes/licencias_diario", as: :reportes_licencias_diario


    #----------------------------------------------------------------------------------------------------------------------------------  
    # Migraciones

    post "/migracion/migrar_hs/:esc", to: 'migracion#migrar_hs'

    get "migrar/", to: 'migracion#migrar'

    post "/migracion/migrar_cargos/:esc", to: 'migracion#migrar_cargos'

    post "/migracion/migrar_auxiliares/:esc", to: 'migracion#migrar_auxiliares'



    #-----------------------------------------------------------------------------------------------------------------------------------
    resources :localidads

    resources :lote_impresions

    resources :tipo_documentos

    resources :situacion_revista

    resources :sexos

    resources :regions

    resources :nivels

    resources :estado_civils

    resources :role_permissions

    devise_for :users, :path => 'user'

    resources :roles
    
    resources :users
    
    resources :grupos

    root :to => "pagina_inicio#index"

  end

end
