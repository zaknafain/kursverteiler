# frozen_string_literal: true

module Admins
  # Controller for all course related requests
  class CoursesController < ApplicationController

    def show
      course  = Course.find(params[:id])
      service = CourseListService.new(course.id)

      send_data service.to_xlsx, filename: "#{course.title} - #{course.teacher_name}.xlsx", type: 'application/xml'
    end

  end
end
