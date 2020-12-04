# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      # Distributes Students to chosen courses. This only works with courses and students atm.
      class Distribute < RailsAdmin::Config::Actions::Base
        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-share-alt'
        end

        register_instance_option :controller do
          proc do
            if request.get? # SHOW
              @not_dist_students = @object.students
                                          .includes(courses: [:poll], selections: [:poll])
                                          .where.not(courses: { poll_id: @object.id })
                                          .order(first_name: :asc, last_name: :asc)
              @courses = @object.courses.includes(students: { selections: [:poll] }).order(title: :asc)

              respond_to do |format|
                format.html { render @action.template_name }
                format.js   { render @action.template_name, layout: false }
              end
            # elsif request.put? # UPDATE
            #   sanitize_params_for!(request.xhr? ? :modal : :update)

            #   @object.set_attributes(params[@abstract_model.param_key])
            #   @authorization_adapter.authorize(:update, @abstract_model, @object) if @authorization_adapter.present?
            #   changes = @object.changes
            #   if @object.save
            #     if @auditing_adapter.present?
            #       @auditing_adapter.update_object(@object, @abstract_model, _current_user, changes)
            #     end

            #     respond_to do |format|
            #       format.html { redirect_to_on_success }
            #       format.js do
            #         render json: { id: @object.id.to_s, label: @model_config.with(object: @object).object_label }
            #       end
            #     end
            #   else
            #     handle_save_error :distribute
            #   end
            end
          end
        end

      end
    end
  end
end
