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

        register_instance_option :http_methods do
          %i[get put]
        end

        register_instance_option :controller do
          proc do
            students = @object.students.includes(courses: [:poll], selections: [:poll])
            @courses = @object.courses.includes(students: [:courses, { selections: [:poll] }]).order(title: :asc)

            if request.get? # SHOW
              @not_dist_students = students.not_distributed_in(@object.id).order(first_name: :asc, last_name: :asc)

              render @action.template_name
            elsif request.put? # UPDATE
              sanitized_params = params.require(:poll).permit(courses_students: %i[student_id course_id])

              sanitized_params[:courses_students].each do |(_, param)|
                student = students.detect { |s| s.id == param[:student_id].to_i }
                student.courses = student.courses.reject { |c| @courses.map(&:id).include?(c.id) }
                student.courses << @courses.detect { |c| c.id == param[:course_id].to_i } if param[:course_id].present?
              end
              @not_dist_students = students.not_distributed_in(@object.id).order(first_name: :asc, last_name: :asc)
              @courses.reload

              render @action.template_name
            end
          end
        end

      end
    end
  end
end
