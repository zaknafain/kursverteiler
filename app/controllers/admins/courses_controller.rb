# frozen_string_literal: true

module Admins
  # Controller for all course related requests
  class CoursesController < ApplicationController

    def show
      course = Course.find(params[:id])
      poll   = course.poll

      service = CourseListService.new(course.id)

      send_data service.to_xslx, filename: "#{poll.title} - #{course.title}.xslx", type: 'application/xml'
    end

  end
end
