ProyectoBase::Application.routes.draw do

  scope '/soft/snpe' do
  
    post "util/buscar_persona/:dni", to: 'util#buscar_persona'

    resources :oficinas    

    get "altas_bajas_horas/importar/", to: "altas_bajas_horas#importar", as: :altas_bajas_horas_importar

    resources :altas_bajas_horas

    resources :establecimientos

    get "establecimientos_de_usuario", to: "establecimientos#establecimientos_de_usuario", as: :establecimientos_de_usuario

    get "establecimiento/seleccionar/:id", to: "establecimientos#seleccionar", as: :establecimiento_seleccionar

    resources :oficinas

    get "pagina_inicio/index"

    resources :personas

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
