# frozen_string_literal: true

# Concern to disallow multiple sign_ins
# see: https://github.com/heartcombo/devise/wiki/How-to-Setup-Multiple-Devise-User-Models#6-fix-cross-model-visits-fancy-name-for-users-can-visit-admins-login-and-viceversa-and-mess-up-your-auth-tokens
module Accessible
  extend ActiveSupport::Concern

  included do
    before_action :check_user
  end

  protected

  def authenticated_student_root_path
    root_path
  end

  def authenticated_admin_root_path
    admins_dashboard_path
  end

  def check_user
    if current_admin
      flash.clear

      redirect_to(authenticated_admin_root_path) and return
    elsif current_student
      flash.clear

      redirect_to(authenticated_student_root_path) and return
    end
  end
end
