Rails.application.routes.draw do
   devise_for :users, :controllers => {registrations: "registrations", sessions: "sessions", passwords: "passwords"}, path: 'user'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  authenticate :user do
    root :to => 'dashboard#index'
    get '/setting' => 'dashboard#edit'
    post '/setting' => 'dashboard#update'
    post "download" => 'accounts#download'
    post "information_download" => 'informations#information_download'
    get "get_file" => 'accounts#get_file'
    get "download_abnormals" => 'abnormals#download'
    post "batch_destroy" => 'accounts#batch_destroy'
    post "batch_destroy_ab" => 'abnormals#batch_destroy'
    post "batch_destroy_files" => "upload_files#batch_destroy_files"
    post "destroy_informations" => 'informations#batch_destroy'
    post "batch_update" => 'informations#batch_update'
    resources :accounts
    resources :informations
    resources :abnormals
    resources :platforms
    post "destroy_platforms" => 'platforms#batch_destroy'
    post "batch_update_platforms" => 'platforms#batch_update'
    resources :download_logs, :import_logs
    get "delete_success" => "informations#delete_success"
    get "toggle_switch" => "setting#toggle_switch"
    get "toggle_file_switch" => "setting#toggle_file_switch"
    resources :upload_files
    get "download_files" => "upload_files#download_files"
  end
  get "import_data" => 'accounts#import_data'
  get "new_import_data" => 'informations#import_data'
  get "new_get_data" => "informations#new_get_data"
  get "new_update_data" => "informations#new_update_data"
  get "check" => "informations#check"
  get "get_data" => "informations#get_data"
  get "update_data" => "informations#update_data"
  get "import_abnormal" => "abnormals#import"

  get "import_platform" => "platforms#import"
  get "get_platform" => "platforms#get_data"
  get "update_platform" => "platforms#update_data"
  get "download_file" => "upload_files#download_file"
  get "download_txt_file" => "upload_files#download_txt_file"
end
