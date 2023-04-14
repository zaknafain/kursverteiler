# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      # Resets the current password of admins or students and sends the devise mail.
      class ResetPassword < RailsAdmin::Config::Actions::Base
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

              ids.each do |id|
                model_class = [Student, Admin].find { |klass| params[:model_name].classify == klass.name }
                next unless model_class

                object = model_class.find_by(id: id)
                object&.send_reset_password_instructions
              end

              flash[:success] = t('admin.flash.successful', name: pluralize(ids.count, @model_config.label),
                                                            action: t('admin.actions.reset_password.done'))

              redirect_to index_path
            end
          end
        end

      end
    end
  end
end
