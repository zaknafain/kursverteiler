# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      # Pauses a student and removes the grade and current distribution.
      class Pause < RailsAdmin::Config::Actions::Base
        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-pause'
        end

        register_instance_option :http_methods do
          %i[get]
        end

        register_instance_option :controller do
          proc do
            @object.grade = nil
            @object.paused_at = Time.zone.now
            @object.courses = @object.courses.select { |c| c.poll.completed }

            if @object.save
              flash[:success] = I18n.t('admin.actions.pause.success', object_label: @object.to_pretty_value)
            else
              flash[:error] = @object.errors.full_messages.join('. ')
            end

            redirect_to index_path
          end
        end

      end
    end
  end
end
