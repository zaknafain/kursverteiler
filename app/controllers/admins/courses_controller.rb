# frozen_string_literal: true

module Admins
  # Controller for all course related requests
  class CoursesController < ApplicationController

    def index
      poll = Poll.find(params[:poll_id])

      zip_filename = I18n.transliterate("#{poll.title} - #{I18n.l Time.zone.today}.zip")
      zip = zip_file(poll.courses)

      send_data zip.string, type: 'application/zip', filename: zip_filename
    end

    def show
      course  = Course.find(params[:id])
      service = CourseListService.new(course.id)

      send_data service.to_xlsx, filename: service.filename, type: 'application/xml'
    end

    private

    def zip_file(courses)
      Zip::OutputStream.write_buffer do |zos|
        courses.each do |course|
          service = CourseListService.new(course.id)
          zos.put_next_entry service.filename
          zos.write service.to_xlsx
        end
      end
    end

  end
end
