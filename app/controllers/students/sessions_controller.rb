# frozen_string_literal: true

module Students
  # Overrites Devise Session Controller for Students because of double model sign in.
  # see: https://github.com/heartcombo/devise/wiki/How-to-Setup-Multiple-Devise-User-Models
  class SessionsController < Devise::SessionsController
    include Accessible
    skip_before_action :check_user, only: :destroy
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    protected

    def authenticated_admin_root_path
      rails_admin_path
    end

    def authenticated_student_root_path
      root_path
    end

    def after_sign_out_path_for(_)
      new_student_session_path
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

  end
end
