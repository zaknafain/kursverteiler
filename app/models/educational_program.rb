# frozen_string_literal: true

# Database model for the educational program the student chose.
# A Poll is only working for some programs.
class EducationalProgram < ApplicationRecord
  include EducationalProgramAdministration

  has_many :polls,  dependent: :destroy
  has_many :grades, dependent: :destroy
  has_one  :running_poll, -> { running_at(Time.zone.today) }, class_name: 'Poll', inverse_of: :educational_program

  validates :name, uniqueness: { case_sensitive: false }
end
