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
          'fas fa-comment'
        end

        register_instance_option :http_methods do
          %i[get put]
        end

        register_instance_option :controller do
          proc do
            @selections = @object.selections.includes(poll: [:courses]).order('polls.valid_until desc')
            @polls = if @object.grade
                       @object.grade.polls.includes(:courses).where.not(id: @selections.map(&:poll_id))
                     else
                       []
                     end
            @courses = @object.courses

            if request.get? # SHOW
              render @action.template_name
            elsif request.put? # UPDATE
              sanitized_params = params.require(:students)
                                       .permit(selections: %i[poll_id top_course_id mid_course_id low_course_id])

              poll_id = sanitized_params[:selections][:poll_id].to_i
              selection = @selections.find_by(poll_id: poll_id) ||
                          @polls.find(poll_id).selections.build(student_id: @object.id)
              selection.assign_attributes(top_course_id: sanitized_params[:selections][:top_course_id],
                                          mid_course_id: sanitized_params[:selections][:mid_course_id],
                                          low_course_id: sanitized_params[:selections][:low_course_id])

              if selection.save
                flash[:success] = t('admin.actions.selections.update.success', object_label: @object.to_pretty_value)
              else
                flash[:error] = selection.errors.full_messages.join('. ')
              end

              @selections = @object.selections.includes(poll: [:courses]).order('polls.valid_until desc')
              @polls = if @object.grade
                         @object.grade.polls.includes(:courses).where.not(id: @selections.map(&:poll_id))
                       else
                         []
                       end

              render @action.template_name
            end
          end
        end

      end
    end
  end
end
