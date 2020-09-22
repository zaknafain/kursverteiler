# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'students#home'

  devise_scope :admin do
    scope :admins do
      root to: 'admins#home', as: 'authenticated_admin_root'
    end
  end
  devise_for :admins, path: 'admins', controllers: { sessions: 'admins/sessions' }

  devise_scope :student do
    root to: 'students#home', as: 'authenticated_student_root'
  end
  devise_for :students, path: 'students', controllers: { sessions: 'students/sessions' }

end
