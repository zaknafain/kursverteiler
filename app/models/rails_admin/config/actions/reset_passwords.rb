# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      # Resets all passwords of students in a class and sends the devise mail.
      class ResetPasswords < RailsAdmin::Config::Actions::Base
        register_instance_option :member? do
          true
        end

        register_instance_option :bulkable? do
          true
        end

        register_instance_option :http_methods do
          %i[post]
        end

        register_instance_option :controller do
          proc do
            if request.post?
              ids = params[:bulk_ids] || Array(@object.id)
              email_count = 0

              ids.each do |id|
                model_class = [Grade].find { |klass| params[:model_name].classify == klass.name }
                next unless model_class

                grade = model_class.find_by(id: id)
                grade&.students&.map(&:send_reset_password_instructions)
                email_count += grade&.students&.length || 0
              end

              flash[:success] = t(
                'admin.flash.successful',
                name: t('admin.actions.reset_passwords.times', count: email_count),
                action: t('admin.actions.reset_passwords.done')
              )

              redirect_to index_path
            end
          end
        end

      end
    end
  end
end
