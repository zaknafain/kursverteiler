# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # devise_scope :admin do
  #   root to: 'admins#index', as: 'authenticated_admin_root'
  # end
  devise_for :admins, path: 'admins', controllers: { sessions: 'admins/sessions' }

  # devise_scope :student do
  #   root to: 'students#index', as: 'authenticated_student_root'
  # end
  devise_for :students, path: 'students', controllers: { sessions: 'students/sessions' }

  # root to: 'home#index'
end
