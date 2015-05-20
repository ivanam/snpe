ProyectoBase::Application.routes.draw do

  

  scope '/soft/snpe' do
  
    post "util/buscar_persona/:dni", to: 'util#buscar_persona'

    post "util/buscar_persona_por_id/:id", to: 'util#buscar_persona_por_id'

    resources :articulos

    resources :asistencia

    get "asistencias/personal_activo/", to: "asistencia#index_personal_activo", as: :asistencia_index_personal_activo

    put "asistencias/editar_asistencia/:id", to: "asistencia#editar_asistencia", as: :asistencia_editar_asistencia

    resources :oficinas    

    get "altas_bajas_horas/bajas/", to: "altas_bajas_horas#index_bajas", as: :altas_bajas_horas_index_bajas

    put "altas_bajas_horas/dar_baja/:id", to: "altas_bajas_horas#dar_baja", as: :altas_bajas_horas_dar_baja

    get "altas_bajas_horas/bajas_efectivas/", to: "altas_bajas_horas#index_bajas_efectivas", as: :altas_bajas_horas_index_bajas_efectivas

    get "altas_bajas_horas/importar/", to: "altas_bajas_horas#importar", as: :altas_bajas_horas_importar

    get "altas_bajas_horas/personal_activo/", to: "altas_bajas_horas#index_personal_activo", as: :altas_bajas_horas_index_personal_activo

    post "altas_bajas_horas/buscar_alta/:id_alta/", to: "altas_bajas_horas#buscar_alta", as: :altas_bajas_horas_buscar_alta

    resources :altas_bajas_horas

    resources :establecimientos

    get "establecimientos_de_usuario", to: "establecimientos#establecimientos_de_usuario", as: :establecimientos_de_usuario

    get "establecimiento/seleccionar/:id", to: "establecimientos#seleccionar", as: :establecimiento_seleccionar

    resources :oficinas

    get "pagina_inicio/index"

    resources :personas

    resources :licencia

    resources :localidads

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
