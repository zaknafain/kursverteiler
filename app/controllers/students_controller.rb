# frozen_string_literal: true

# Controller, that handles all pages made directly for students.
class StudentsController < ApplicationController
  before_action :authenticate_student!

  def home; end
end
