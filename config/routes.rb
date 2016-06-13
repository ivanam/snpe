ProyectoBase::Application.routes.draw do


  scope '/soft/snpe' do

    ActiveAdmin.routes(self)
  
    post "util/buscar_persona/:dni", to: 'util#buscar_persona'

    post "util/buscar_persona_por_id/:id", to: 'util#buscar_persona_por_id'

    post "util/buscar_estados_altas_bajas_hora/:id", to: 'util#buscar_estados_altas_bajas_hora'    

    post "util/buscar_estados_cargo/:id", to: 'util#buscar_estados_cargo'  

    resources :articulos

    #---------------------------------------------------------------------------------------------------------------------------------------
    
    resources :empresas

    resources :asistencia

    #Páginas de asistencia

    get "asistencias/index_cargo/", to: "asistencia#index_cargo", as: :asistencia_index_cargo

    get "asistencias/index_novedades_cargo/", to: "asistencia#index_novedades_cargo", as: :asistencia_index_novedades_cargo

    #Datatables

    get "asistencias/personal_activo/", to: "asistencia#index_personal_activo", as: :asistencia_index_personal_activo

    get "asistencias/personal_cargo/", to: "asistencia#personal_cargo", as: :asistencia_personal_cargo

    get "asistencias/novedades_cargo/", to: "asistencia#novedades_cargo", as: :asistencia_novedades_cargo

    #Otras funciones

    get "asistencias/cargos_informar", to: "asistencia#cargos_informar", as: :cargos_informar_asistencia

    get "asistencias/cargos_imprimir", to: "asistencias#cargos_imprimir", as: :cargos_imprimir_asistencia

    put "asistencias/editar_asistencia/:id", to: "asistencia#editar_asistencia", as: :asistencia_editar_asistencia

    put "asistencias/editar_asistencia_cargo/:id", to: "asistencia#editar_asistencia_cargo", as: :asistencia_editar_asistencia_cargo

    #---------------------------------------------------------------------------------------------------------------------------------------

    resources :oficinas    

    get "altas_bajas_horas/bajas/", to: "altas_bajas_horas#index_bajas", as: :altas_bajas_horas_index_bajas

    get "altas_bajas_horas/notificadas/", to: "altas_bajas_horas#index_notificadas", as: :altas_bajas_horas_index_notificadas    

    put "altas_bajas_horas/dar_baja/:id", to: "altas_bajas_horas#dar_baja", as: :altas_bajas_horas_dar_baja

    get "altas_bajas_horas/bajas_efectivas/", to: "altas_bajas_horas#index_bajas_efectivas", as: :altas_bajas_horas_index_bajas_efectivas

    get "altas_bajas_horas/importar/", to: "altas_bajas_horas#importar", as: :altas_bajas_horas_importar

    get "altas_bajas_horas/importar_recibos/", to: "altas_bajas_horas#importar_recibos", as: :altas_bajas_horas_importar_recibos

    get "altas_bajas_horas/personal_activo/", to: "altas_bajas_horas#index_personal_activo", as: :altas_bajas_horas_index_personal_activo

    post "altas_bajas_horas/buscar_alta/:id_alta/", to: "altas_bajas_horas#buscar_alta", as: :altas_bajas_horas_buscar_alta

    get "altas_bajas_horas/:id/editar_alta/", to: "altas_bajas_horas#editar_alta", as: :altas_bajas_horas_editar_alta

    patch "altas_bajas_horas/guardar_edicion/:id", to: "altas_bajas_horas#guardar_edicion", as: :altas_bajas_horas_guardar_edicion

    get "altas_bajas_horas/notificar/:id", to: "altas_bajas_horas#notificar", as: :altas_bajas_horas_notificar

    put "altas_bajas_horas/cancelar/:id", to: "altas_bajas_horas#cancelar", as: :altas_bajas_horas_cancelar

    get "altas_bajas_horas/chequear/:id", to: "altas_bajas_horas#chequear", as: :altas_bajas_horas_chequear

    get "altas_bajas_horas/imprimir/:id", to: "altas_bajas_horas#imprimir", as: :altas_bajas_horas_imprimir

    get "altas_bajas_horas/notificar_baja/:id", to: "altas_bajas_horas#notificar_baja", as: :altas_bajas_horas_notificar_baja

    get "altas_bajas_horas/cancelar_baja/:id", to: "altas_bajas_horas#cancelar_baja", as: :altas_bajas_horas_cancelar_baja

    get "altas_bajas_horas/chequear_baja/:id", to: "altas_bajas_horas#chequear_baja", as: :altas_bajas_horas_chequear_baja

    get "altas_bajas_horas/imprimir_baja/:id", to: "altas_bajas_horas#imprimir_baja", as: :altas_bajas_horas_imprimir_baja

    get "altas_bajas_horas/novedades/", to: "altas_bajas_horas#index_novedades", as: :horas_index_novedades

    get "altas_bajas_horas/cola-impresion/", to: "altas_bajas_horas#index_cola_impresion", as: :horas_index_cola_impresion

    get "altas_bajas_horas/imprimir-cola/", to: "altas_bajas_horas#imprimir_cola", as: :horas_imprimir_cola

    get "altas_bajas_horas/cancelar-cola/", to: "altas_bajas_horas#cancelar_cola", as: :horas_cancelar_cola

    resources :altas_bajas_horas

    #--------------------------- Bloque de Cargos -------------------------------------------------------------------------------------
    resources :cargos

    get "cargo/no_docente/", to: "cargos#index_no_docente", as: :cargos_index_no_docente
       
    get "cargo/bajas/", to: "cargos#index_bajas", as: :cargos_index_bajas
    
    get "cargo/cancelar-cola/", to: "cargos#cancelar_cola", as: :cargo_cancelar_cola

    get "cargo/:id/editar_alta/", to: "cargos#editar_alta", as: :cargo_editar_alta

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

    #----------------------------------------------------------------------------------------------------------------------------------

    resources :establecimientos

    get "establecimientos_de_usuario", to: "establecimientos#establecimientos_de_usuario", as: :establecimientos_de_usuario

    get "establecimiento/seleccionar/:id", to: "establecimientos#seleccionar", as: :establecimiento_seleccionar

    resources :estados

    resources :oficinas

    get "pagina_inicio/index"

    resources :personas

    resources :licencia

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

    root :to => "pagina_inicio#index"

  end

end
