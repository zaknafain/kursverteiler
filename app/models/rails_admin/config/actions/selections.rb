# frozen_string_literal: true

module RailsAdmin
  module Config
    module Actions
      # Shows and updates selections of students.
      class Selections < RailsAdmin::Config::Actions::Base
        register_instance_option :member? do
          true
        end

        register_instance_option :link_icon do
          'icon-comment'
        end

        register_instance_option :http_methods do
          %i[get put]
        end

        register_instance_option :controller do
          proc do
            @selections = @object.selections.includes(poll: [:courses]).order('polls.valid_until desc')
            @polls      = @object.grade.polls.includes(:courses).where.not(id: @selections.map(&:poll_id))

            if request.get? # SHOW
              render @action.template_name
            elsif request.put? # UPDATE
              sanitized_params = params.require(:students)
                                       .permit(selections: %i[poll_id top_course_id mid_course_id low_course_id])

              poll_id = sanitized_params[:selections][:poll_id].to_i
              selection = @selections.find_by(poll_id: poll_id) ||
                          @polls.find(poll_id).selections.build(student_id: @object.id)
              selection.assign_attributes(top_course_id: sanitized_params[:selections][:top_course_id].to_i,
                                          mid_course_id: sanitized_params[:selections][:mid_course_id].to_i,
                                          low_course_id: sanitized_params[:selections][:low_course_id].to_i)

              flash[:error] = selection.errors.full_messages.join('. ') unless selection.save

              @selections = @object.selections.includes(poll: [:courses]).order('polls.valid_until desc')
              @polls      = @object.grade.polls.includes(:courses).where.not(id: @selections.map(&:poll_id))

              render @action.template_name
            end
          end
        end

      end
    end
  end
end
