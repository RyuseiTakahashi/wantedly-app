Rails.application.routes.draw do

  root :to => 'logins#index'

  resource :logins, only: [:show, :create, :destroy] do
  end

  resources :skills, only: [:show, :new, :create] do
    collection do
      post :ajax_update
    end
  end

  resources :skill_masters, only: [:new, :create] do
    
  end

  resources :users, only: [:show, :new, :create] do
  end

  # get 'logins/index'
  # root to: 'login#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end