# frozen_string_literal: true

# Database model for the educational program the student chose.
# A Poll is only working for some programs.
class EducationalProgram < ApplicationRecord
  include EducationalProgramAdministration

  has_many :polls,  dependent: :destroy
  has_many :grades, dependent: :destroy

  validates :name, uniqueness: { case_sensitive: false }
end
