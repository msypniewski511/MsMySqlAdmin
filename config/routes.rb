Rails.application.routes.draw do
  root 'main#index'
  resources :users

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  
  get 'main/index'
  get 'main/abot'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # I tried to divide actions on database server to simillar of REST verbs and resources
  resources :databases, except: [:update, :edit] do
  	collection do
  	  get 'server_info'
      post 'server_details'
      get 'change_server'
      post 'change_server'
  	end
    resources :tables do
      member do
        get 'show_records'
      end
      resources :columns
    end
  end
end
