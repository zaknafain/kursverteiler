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
              @not_dist_students = students.not_distributed_in(@object.id).order(last_name: :asc, first_name: :asc)

              render @action.template_name
            elsif request.put? # UPDATE
              sanitized_params = params.require(:poll).permit(:completed, courses_students: %i[student_id course_id])

              if sanitized_params[:courses_students].present?
                sanitized_params[:courses_students].each do |(_, param)|
                  student = students.detect { |s| s.id == param[:student_id].to_i }
                  student.courses = student.courses.reject do |course|
                    @courses.map(&:id).include?(course.id) && param[:course_id].to_i != course.id
                  end
                  if param[:course_id].present? && student.courses.map(&:id).exclude?(param[:course_id].to_i)
                    student.courses << @courses.detect { |c| c.id == param[:course_id].to_i }
                  end
                end
                @courses.reload
              elsif sanitized_params[:completed]
                @object.update(completed: Time.zone.now)
                @object.courses.includes(:students).find_each do |course|
                  course.students.each do |student|
                    StudentsMailer.with(student: student, poll: @object, course: course)
                                  .inform_about_distribution
                                  .deliver_now
                  end
                end
              end
              @not_dist_students = students.not_distributed_in(@object.id).order(last_name: :asc, first_name: :asc)

              render @action.template_name
            end
          end
        end

      end
    end
  end
end
