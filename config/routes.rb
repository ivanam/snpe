ProyectoBase::Application.routes.draw do
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
