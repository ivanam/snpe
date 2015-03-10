ProyectoBase::Application.routes.draw do
  resources :establecimientos

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
