# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/administration', as: 'rails_admin'

  get "up" => "rails/health#show", as: :rails_health_check

  root to: 'students#show'

  devise_for :admins,   path: 'admins',   controllers: { sessions: 'admins/sessions'   }
  devise_for :students, path: 'students', controllers: { sessions: 'students/sessions' }

  resources :students, only: %i[show update]

  namespace :admins do
    resources :courses, only: %i[index show]
  end
end
