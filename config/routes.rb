# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount RailsAdmin::Engine => '/administration', as: 'rails_admin'

  root to: 'students#show'

  devise_for :admins,   path: 'admins',   controllers: { sessions: 'admins/sessions'   }
  devise_for :students, path: 'students', controllers: { sessions: 'students/sessions' }

  resources :students, only: %i[show update]
end
