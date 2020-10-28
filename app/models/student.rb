# frozen_string_literal: true

# Database Model for the regular student user.
# For admins see Admin class.
class Student < ApplicationRecord
  include StudentAdministration
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :grade
  has_one  :educational_program, through: :grade
  has_many :selections, dependent: :destroy
  has_many :current_selections, -> { current },                 class_name: 'Selection', inverse_of: :student
  has_one  :top_selection,      -> { current.top_priority },    class_name: 'Selection', inverse_of: :student
  has_one  :mid_selection,      -> { current.medium_priority }, class_name: 'Selection', inverse_of: :student
  has_one  :low_selection,      -> { current.low_priority },    class_name: 'Selection', inverse_of: :student

  validates :first_name, :last_name, presence: true
end
