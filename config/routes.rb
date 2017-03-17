Rails.application.routes.draw do
  resources :users
  root 'main#index'
  get 'main/index'
  get 'main/abot'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :databases, except: [:update, :edit] do
  	collection do
  	  get 'server_info'
  	end
    resources :tables do
      member do
        get 'show_records'
        get 'new_column'
        post 'add_column'
      end
      resources :columns
    end
  end
end
