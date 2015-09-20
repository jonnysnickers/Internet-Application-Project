Rails.application.routes.draw do

  get 'sessions/new'

  root             'static_pages#home'
  get 'help'    => 'static_pages#help'
  get 'about'   => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'sign_in_success'  => 'static_pages#sign_in_success'
  get 'signup'  => 'users#new'
  
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  resources :users
  resources :duties

  post 'duties/:id' => 'duties#update_duty'
  
  get 'main_panel' => 'admin_panels#main_panel'
  
  get '/admin_patients' => 'admin_panels#patients_panel'
  post "/enable_patient/:id" => "admin_panels#enable_patient"
  post "/delete_patient/:id" => "admin_panels#destroy_patient"
  
  get '/admin_doctors' => 'admin_panels#doctors_panel'
  get '/admin_new_doctor' => 'admin_panels#new_doctor'
  post "/create_doctor" => "admin_panels#create_doctor" 
  post "/delete_doctor/:id" => "admin_panels#destroy_doctor"

  get "/admin_clinics" => 'admin_panels#clinics_panel'
  get "/admin_new_clinic" => 'admin_panels#new_clinic'
  post "/create_clinic" => 'admin_panels#create_clinic'
  post "delete_clinic/:id" => "admin_panels#destroy_clinic"
  
  get "/admin_appointments" => "admin_panels#appointments_panel"
  post "delete_appointment/:id" => "admin_panels#destroy_appointment"
  
  get "/admin_doc_cli" => "admin_panels#doc_cli_panel"
  post "/create_doc_cli" => "admin_panels#create_cli_doc"
  post "/delete_doc_cli/:id" => "admin_panels#destroy_doc_cli"
  
  get "/appointments/:id" => "appointments#show"
  get "/new_appointment/:id" => "appointments#new_appointment"
  get "/new_appointment2/:id" => "appointments#new_appointment2"
  post "/new_appointment2" => "appointments#create_appointment"
  get "/user_appointments/:id" => "appointments#user_appointments"
  post "/user_enable_appointment/:id" => "appointments#enable_appointment"
  post "/user_delete_appointment/:id" => "appointments#destroy_appointment"
  
  post "/specific_app_doc/:id" => "appointments#make_appointment_doc"
  post "/specific_app_cli/:id" => "appointments#make_appointment_cli"
  
end
