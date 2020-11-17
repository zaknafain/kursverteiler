# frozen_string_literal: true

# Database Model for the regular student user.
# For admins see Admin class.
class Student < ApplicationRecord
  include StudentAdministration
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  belongs_to :grade
  has_many :selections, dependent: :destroy
  has_one :current_poll, -> { running_at(Time.zone.today) }, through: :grade, source: :polls
  has_one :current_selection, -> { current }, class_name: 'Selection', inverse_of: :student
  has_one :current_top_course, through: :current_selection, source: :top_course
  has_one :current_mid_course, through: :current_selection, source: :mid_course
  has_one :current_low_course, through: :current_selection, source: :low_course

  validates :first_name, :last_name, presence: true

end
