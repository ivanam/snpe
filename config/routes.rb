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

    get "/docenteInscripcion/:id", to: "inscripcions#docenteInscripcion", as: :docenteInscripcion

    get "buscar_cv_persona/", to: 'inscripcions#buscar_cv_persona'

    post "/users/buscar_persona/:dni", to: 'users#buscar_persona'

    get "inscripcions/buscar_persona/:dni", to: 'inscripcions#buscar_persona'

    get "inscripcions/new/:id", to: "inscripcions#new", as: :new_inscripcions

    get "inscripcions/form_user"

    get "cargo_inscrip_docs/new", to: "cargo_inscrip_docs#new", as: :new_cargo_inscrip_docs

    get "/cargo_inscrip_docs/index", to: 'cargo_inscrip_docs#index'

    get "/titulos/index", to: 'titulos#index'

    get "titulos/new", to: "titulos#new", as: :new_titulos 

    get "/titulo_personas/index", to: 'titulo_personas#index'

    get "/titulo_personas/index", to: 'titulo_personas#index'

    resources :especialidads

    resources :prestadors

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
   
    resources :tipo_horas
    
    resources :lugar_pagos

    resources :formulario_inscrip_docente

    resources :rubros

    resources :inscripcions

    resources :funcions

    resources :suplentes

    resources :tipo_plans
    
    resources :titulo_personas

    resources :titulos

    resources :cargo_inscrip_docs

    resources :planilla_incompatibilidads

    resources :concursos

    resources :motivo_bajas


   resources :cargos_especials

    get "/concursos/:id/estadisticas", to: "concursos#estadisticas", as: :concurso_estadisticas

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

    get "asistencias/horas_imprimir", to: "asistencia#horas_imprimir", as: :horas_imprimir_asistencia

    get "asistencias/cargos_imprimir", to: "asistencia#cargos_imprimir", as: :cargos_imprimir_asistencia

    get "asistencias/cargo_no_docentes_imprimir", to: "asistencia#cargo_no_docentes_imprimir", as: :cargo_no_docentes_imprimir_asistencia

    put "asistencias/editar_asistencia/:id", to: "asistencia#editar_asistencia", as: :asistencia_editar_asistencia

    put "asistencias/editar_asistencia_cargo/:id", to: "asistencia#editar_asistencia_cargo", as: :asistencia_editar_asistencia_cargo

    put "asistencias/editar_asistencia_cargo_no_docente/:id", to: "asistencia#editar_asistencia_cargo_no_docente", as: :asistencia_editar_asistencia_cargo_no_docente

    #---------------------------------------------------------------------------------------------------------------------------------------

    resources :oficinas    

    get "altas_bajas_horas/:id/desglose", to: "altas_bajas_horas#desglose", as: :altas_bajas_horas_desglose

    patch "altas_bajas_horas/:id/desglose", to: "altas_bajas_horas#guardar_desglose", as: :altas_bajas_horas_guardar_desglose

    get "altas_bajas_horas/bajas/", to: "altas_bajas_horas#index_bajas", as: :altas_bajas_horas_index_bajas
 
    put "altas_bajas_horas/editar_campos/", to: "altas_bajas_horas#editar_campos", as: :altas_bajas_horas_editar_campos

    
    get "altas_bajas_horas/modificacion/", to: "altas_bajas_horas#modificacion", as: :altas_bajas_horas_modificacion

    get "altas_bajas_horas/notificadas/", to: "altas_bajas_horas#index_notificadas", as: :altas_bajas_horas_index_notificadas    

    get "altas_bajas_horas/bajas_ingresadas/", to: "altas_bajas_horas#index_bajas_ingresadas", as: :altas_bajas_horas_index_bajas_ingresadas  

    get "altas_bajas_horas/notificar_baja/:id", to: "altas_bajas_horas#notificar_baja", as: :altas_bajas_horas_notificar_bajas



    put "altas_bajas_horas/dar_baja/:id", to: "altas_bajas_horas#dar_baja", as: :altas_bajas_horas_dar_baja

    post "altas_bajas_horas/dar_baja/", to: "altas_bajas_horas#dar_baja", as: :altas_bajas_horas_dar_bajas

    get "altas_bajas_horas/bajas_efectivas/", to: "altas_bajas_horas#index_bajas_efectivas", as: :altas_bajas_horas_index_bajas_efectivas
    
    get "altas_bajas_horas/bajas_notificadas_chequear/", to: "altas_bajas_horas#index_bajas_notificadas_chequear", as: :index_bajas_notificadas_chequear

    get "altas_bajas_horas/importar/", to: "altas_bajas_horas#importar", as: :altas_bajas_horas_importar

    get "altas_bajas_horas/importar_recibos/", to: "altas_bajas_horas#importar_recibos", as: :altas_bajas_horas_importar_recibos

    get "altas_bajas_horas/personal_activo/", to: "altas_bajas_horas#index_personal_activo", as: :altas_bajas_horas_index_personal_activo

    post "altas_bajas_horas/buscar_alta/:id_alta/", to: "altas_bajas_horas#buscar_alta", as: :altas_bajas_horas_buscar_alta

    get "altas_bajas_horas/:id/editar_alta/", to: "altas_bajas_horas#editar_alta", as: :altas_bajas_horas_editar_alta

    get "altas_bajas_horas/:id/modificar/", to: "altas_bajas_horas#modificar", as: :altas_bajas_horas_modificar

     get "altas_bajas_horas/obtener_id/:id", to: "altas_bajas_horas#obtener_id", as: :altas_bajas_horas_obtener_id


    patch "altas_bajas_horas/guardar_edicion/:id", to: "altas_bajas_horas#guardar_edicion", as: :altas_bajas_horas_guardar_edicion

    post "altas_bajas_horas/guardar_edicion2", to: "altas_bajas_horas#guardar_edicion2", as: :altas_bajas_horas_guardar_edicion2
    
    get "altas_bajas_horas/guardar_edicion3", to: "altas_bajas_horas#guardar_edicion3", as: :altas_bajas_horas_guardar_edicion3
    
    get "altas_bajas_horas/notificar/:id", to: "altas_bajas_horas#notificar", as: :altas_bajas_horas_notificar

    put "altas_bajas_horas/cancelar/:id", to: "altas_bajas_horas#cancelar", as: :altas_bajas_horas_cancelar

    get "altas_bajas_horas/chequear/:id", to: "altas_bajas_horas#chequear", as: :altas_bajas_horas_chequear

    get "altas_bajas_horas/imprimir/:id", to: "altas_bajas_horas#imprimir", as: :altas_bajas_horas_imprimir

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
    
    get "cargo/guardar_edicion3", to: "cargos#guardar_edicion3", as: :cargos_guardar_edicion3

    patch "cargo/guardar_edicion/:id", to: "cargos#guardar_edicion", as: :cargo_guardar_edicion

    get "cargo/imprimir-cola/", to: "cargos#imprimir_cola", as: :cargos_imprimir_cola

    get "cargo/novedades/", to: "cargos#index_novedades", as: :cargos_index_novedades

    #Cambios de estado
    
    put "cargo/cancelar/:id", to: "cargos#cancelar", as: :cargo_cancelar

    get "cargo/cancelar_baja/:id", to: "cargos#cancelar_baja", as: :cargo_cancelar_baja

    get "cargo/chequear/:id", to: "cargos#chequear", as: :cargo_chequear

    get "cargo/chequear_baja/:id", to: "cargos#chequear_baja", as: :cargo_chequear_baja

    put "cargo/dar_baja/:id", to: "cargos#dar_baja", as: :cargo_dar_baja

    post "cargo/dar_baja/", to: "cargos#dar_baja", as: :cargo_dar_bajas

    get "cargo/imprimir/:id", to: "cargos#imprimir", as: :cargo_imprimir

    get "cargo/notificar/:id", to: "cargos#notificar", as: :cargo_notificar

    #Datatables
    
    get "cargo/cargos_bajas/", to: "cargos#cargos_bajas", as: :cargos_bajas

    get "cargo/bajas_efectivas/", to: "cargos#index_bajas_efectivas", as: :cargos_index_bajas_efectivas

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

    post "cargo_no_docente/guardar_edicion3", to: "cargo_no_docentes#guardar_edicion3", as: :cargo_no_docentes_guardar_edicion2

    post "cargo_no_docente/guardar_edicion2", to: "cargo_no_docentes#guardar_edicion2", as: :cargo_no_docentes_guardar_edicion3

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

    get "cargo_no_docente/bajas_efectivas/", to: "cargo_no_docentes#index_bajas_efectivas", as: :cargo_no_docentes_index_bajas_efectivas

    put "cargo_no_docente/dar_baja/:id", to: "cargo_no_docentes#dar_baja", as: :cargo_no_docentes_dar_baja

    post "cargo_no_docente/dar_baja/", to: "cargo_no_docentes#dar_baja", as: :cargo_no_docentes_dar_bajas

    get "cargo_no_docente/cancelar_baja/:id", to: "cargo_no_docentes#cancelar_baja", as: :cargo_no_docente_cancelar_baja

    get "cargo_no_docente/chequear_baja/:id", to: "cargo_no_docentes#chequear_baja", as: :cargo_no_docente_chequear_baja

    resources :establecimientos

    get "establecimientos_de_usuario", to: "establecimientos#establecimientos_de_usuario", as: :establecimientos_de_usuario

    get "establecimiento/pof", to: "establecimientos#pof", as: :establecimiento_pof

    get "establecimiento/pof_excel", to: "establecimientos#pof_excel", as: :establecimiento_pof_excel

    get "establecimiento/desglose_excel", to: "establecimientos#desglose_excel", as: :desglose_excel

    get "establecimiento/seleccionar/:id", to: "establecimientos#seleccionar", as: :establecimiento_seleccionar

    resources :estados

    resources :oficinas

    get "pagina_inicio/index"

    resources :personas

    #-------------------------------------------------------------------------------

    resources :licencia
    resources :util do
        get :autocomplete_persona_apeynom, :on => :collection
    end

    get "licencias/poner_establecimientos", to: 'licencia#poner_establecimientos'
    get "licencias/autocomplete_persona_apeynom", to: 'licencia#get_autocomplete_items', as: :autocomplete_persona_apeynom_licencia

    get "licencias/sin_goce", to: 'licencia#sin_goce', as: :licencias_sin_goce
    get "licencias/sin_certificado", to: 'licencia#sin_certificado', as: :licencias_sin_certificado

    get "util/buscar_hora/:dni", to: 'util#buscar_hora'
    post "util/buscar_hora/:dni", to: 'util#buscar_hora'
    get 'licencia/altas_bajas_horas_licencia_permitida/:dni', to: 'licencia#altas_bajas_horas_licencia_permitida', as: :altas_bajas_horas_licencia_permitida
    get 'licencia/cargos_licencia_permitida/:dni', to: 'licencia#cargos_licencia_permitida', as: :cargos_licencia_permitida
    get 'personas/editar_persona/:dni', to: 'personas#editar_persona', as: :editar_persona
    get 'licencia/licencia_dadas/:dni', to: 'licencia#licencia_dadas', as: :licencia_dadas
    get 'licencia/buscar_articulo_dias_hora/:id_articulo/:id_horas', to: 'licencia#buscar_articulo_dias_hora', as: :buscar_articulo_dias_hora
    get 'licencia/buscar_articulo_dias_cargo/:id_articulo/:id_cargos', to: 'licencia#buscar_articulo_dias_cargo', as: :buscar_articulo_dias_cargo
    get 'licencia/buscar_articulo_dias_cargo_no_docente/:id_articulo/:id_cargos_no_docentes', to: 'licencia#buscar_articulo_dias_cargo_no_docente', as: :buscar_articulo_dias_cargo_no_docente
    get 'licencias/listado_licencias', to: 'licencia#listado_licencias', as: :listado_licencias
    get 'licencias/listado_licencias_todas', to: 'licencia#listado_licencias_todas', as: :listado_licencias_todas
    get 'licencias/licencias_chequeadas_horas', to: 'licencia#licencias_chequeadas_horas', as: :licencias_chequeadas_horas
    get 'licencias/listado_licencias_cnds_sg_chequeadas', to: 'licencia#listado_licencias_cnds_sg_chequeadas', as: :listado_licencias_cnds_sg_chequeadas
    get 'licencias/listado_licencias_carg_sg_chequeadas', to: 'licencia#listado_licencias_carg_sg_chequeadas', as: :listado_licencias_carg_sg_chequeadas
    get 'licencias/listado_licencias_canceladas_horas', to: 'licencia#listado_licencias_canceladas_horas', as: :listado_licencias_canceladas_horas
    get 'licencias/listado_licencias_canceladas_cargos', to: 'licencia#listado_licencias_canceladas_cargos', as: :listado_licencias_canceladas_cargos
    get 'licencias/listado_licencias_canceladas_cargos_no_docentes', to: 'licencia#listado_licencias_canceladas_cargos_no_docentes', as: :listado_licencias_canceladas_cargos_no_docentes


    
    post 'licencia/cancelar_sin_goce' , to: 'licencia#cancelar_sin_goce', as: :cancelar_sin_goce
    get 'licencias/listado_licencias_cnds', to: 'licencia#listado_licencias_cnds', as: :listado_licencias_cnds
    get 'licencias/listado_licencias_carg', to: 'licencia#listado_licencias_carg', as: :listado_licencias_carg
    get 'licencias/parte_diario', to: 'licencia#parte_diario', as: :parte_diario
    
    get 'licencias/listado_licencias_todas_lic', to: 'licencia#listado_licencias_todas_lic', as: :listado_licencias_todas_lic
    get 'licencias/listado_licencias_cnds_sg', to: 'licencia#listado_licencias_cnds_sg', as: :listado_licencias_cnds_sg
    get 'licencias/listado_licencias_carg_sg', to: 'licencia#listado_licencias_carg_sg', as: :listado_licencias_carg_sg
    get 'licencias/listado_licencias_historico_agente', to: 'licencia#listado_licencias_historico_agente', as: :listado_licencias_historico_agente

    
    get 'licencias/cargos_no_docentes_licencia_permitida', to: 'licencia#cargos_no_docentes_licencia_permitida', as: :cargos_no_docentes_licencia_permitida

    
    
    post "licencia/guardar_licencia_horas/", to: "licencia#guardar_licencia_horas", as: :guardar_licencia_horas
    post "licencia/guardar_licencia_cargos/", to: "licencia#guardar_licencia_cargos", as: :guardar_licencia_cargos
    post "licencia/guardar_licencia_cargos_no_docentes/", to: "licencia#guardar_licencia_cargos_no_docentes", as: :guardar_licencia_cargos_no_docentes
    post "licencia/guardar_licencia_horas2/", to: "licencia#guardar_licencia_horas2", as: :guardar_licencia_horas2
    post "licencia/guardar_licencia_cargos2/", to: "licencia#guardar_licencia_cargos2", as: :guardar_licencia_cargos2

    post "licencia/guardar_licencia_cargos_no_docentes2/", to: "licencia#guardar_licencia_cargos_no_docentes2", as: :guardar_licencia_cargos_no_docentes2
    post "licencia/guardar_licencia_obs/", to: "licencia#guardar_licencia_obs", as: :guardar_licencia_obs


    post "licencia/guardar_licencia_final/:id_lic/:fecha_inicio/:fecha_fin(/:por_baja)", to: "licencia#guardar_licencia_final", as: :guardar_licencia_final
    post "licencia/editar_comentario_licencia_final/", to: "licencia#editar_comentario_licencia_final", as: :editar_comentario_licencia_final
    post "licencia/cancelar_licencia/:id_lic", to: "licencia#cancelar_licencia", as: :cancelar_licencia

    put "licencias/editar_licencias_cnds/:id", to: "licencias#editar_licencias_cnds", as: :editar_licencias_cnds
    get "licencias/chequear_cargada/", to: "licencia#chequear_cargada", as: :licencias_chequear_cargada
    get "licencias/chequear_finalizada/", to: "licencia#chequear_finalizada", as: :licencias_chequear_finalizada
    get "licencias/obtenerdatarange/", to: "licencia#obtenerdatarange", as: :licencias_obtenerdatarange
    get "licencias/obtenerdatarange2/", to: "licencia#obtenerdatarange2", as: :licencias_obtenerdatarange2
    get "licencias/obtenerdatarange3/", to: "licencia#obtenerdatarange3", as: :licencias_obtenerdatarange3

    #Articulos que permiten otro origanismo
    get 'articulos/:id/permite_otro_organismo', to: 'articulos#permite_otro_organismo', as: :permite_otro_organismo


    get "traslados/reporte", to: "traslados#reporte", as: :traslados_reporte
    get "licencias/licencias_sin_goce_canceladas", to: "licencia#licencias_sin_goce_canceladas", as: :licencias_sin_goce_canceladas

    get 'altas_bajas_horas/:id/historial', to: 'altas_bajas_horas#show', as: :historial_agente
    get 'cargos/:id/historial', to: 'cargos#show', as: :historial_agente_cargos
    get 'cargo_no_docentes/:id/historial', to: 'cargo_no_docentes#show', as: :historial_agente_cargos_no_docentes





    #----------------Prestadores y Especialidades----------------------

    resources :especialidads

    resources :prestadors
    
    #----------------Reportes--------------------------------------------------------
   
    get "reportes/index"

    get "reportes/licencias_diario", as: :reportes_licencias_diario

    get "reportes/historial_agente_activo", as: :historial_agente_activo

    get 'reportes/horas/:dni', to: 'reportes#horas', as: :agente_activo_horas

    get 'reportes/cargos/:dni', to: 'reportes#cargos', as: :agente_activo_cargos

    get 'reportes/auxiliares/:dni', to: 'reportes#auxiliares', as: :agente_activo_auxiliares




    #----------------------------------------------------------------------------------------------------------------------------------  
    # Migraciones

    get "/migracion/migracion_bajas/", to: 'migracion#migracion_bajas'

    get "/migracion/migracion_bajas_cargos/", to: 'migracion#migracion_bajas_cargos'

    get "/migracion/eliminar_cargos_repetidos/", to: 'migracion#eliminar_cargos_repetidos'

    get "/migracion/migracion_bajas_cargos_sin_secuencia/", to: 'migracion#migracion_bajas_cargos_sin_secuencia'

    get "/migracion/migracion_bajas_cargos_no_docentes/", to: 'migracion#migracion_bajas_cargos_no_docentes'

    


    


    get "/migracion/migrar_hs/", to: 'migracion#migrar_hs'

    get "/migracion/migracion_inversa/", to: 'migracion#migracion_inversa'

    get "/migracion/pofs/:esc", to: 'migracion#pofs'

    get "migrar/", to: 'migracion#migrar'

    get "migracion/listado_a_informar/", to: 'migracion#listado_a_informar', as: :migracion_listado_a_informar

    get "migracion/migrar_cargos/", to: 'migracion#migrar_cargos'

    get "/migracion/migrar_auxiliares/", to: 'migracion#migrar_auxiliares'

    get "registros_para_solucionar/reporte", to: 'registros_para_solucionar#reporte', as: :registros_para_solucionar_reporte

    get "registros_para_solucionar/chequear_registro/:id", to: 'registros_para_solucionar#chequear_registro', as: :registros_para_solucionar_chequear_registro

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

    devise_for :users, :path => 'user', controllers: { registrations: "users/registrations"}
    
    resources :roles
    
    resources :users
    
    resources :grupos

    resources :juntafuncions

    root :to => "pagina_inicio#index"

  end

end
