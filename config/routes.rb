Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :databases, except: [:update, :edit] do
    resources :tables do
      member do
        get 'show_description'
      end
    end
  end
end
