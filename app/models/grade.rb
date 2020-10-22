# frozen_string_literal: true

# Database model for the classes the student is part of.
class Grade < ApplicationRecord
  belongs_to :educational_program
  has_many :students, dependent: :destroy

  validates :name, uniqueness: { case_sensitive: false }
end
