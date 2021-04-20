Rails.application.routes.draw do
   devise_for :users, :controllers => {registrations: "registrations", sessions: "sessions", passwords: "passwords"}, path: 'user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  authenticate :user do
    root :to => 'dashboard#index'
    get '/setting' => 'dashboard#edit'
    post '/setting' => 'dashboard#update'
    post "download" => 'accounts#download'
    get "get_file" => 'accounts#get_file'
    get "download_abnormals" => 'abnormals#download'
    post "batch_destroy" => 'accounts#batch_destroy'
    get "batch_destroy_ab" => 'abnormals#batch_destroy'
    get "destroy_informations" => 'informations#batch_destroy'
    post "batch_update" => 'informations#batch_update'
    resources :accounts
    resources :informations
    resources :abnormals
    resources :platforms
    get "destroy_platforms" => 'platforms#batch_destroy'
    get "batch_update_platforms" => 'platforms#batch_update'
    resources :download_logs, :import_logs
    get "delete_success" => "informations#delete_success"
    get "toggle_switch" => "setting#toggle_switch"
  end
  get "import_data" => 'accounts#import_data'
  get "get_data" => "informations#get_data"
  get "update_data" => "informations#update_data"
  get "import_abnormal" => "abnormals#import"

  get "import_platform" => "platforms#import"
  get "get_platform" => "platforms#get_data"
  get "update_platform" => "platforms#update_data"
end
