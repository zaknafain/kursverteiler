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
  has_one :current_selection, -> { current }, class_name: 'Selection', inverse_of: :student, autosave: true
  has_one :current_top_course, through: :current_selection, source: :top_course
  has_one :current_mid_course, through: :current_selection, source: :mid_course
  has_one :current_low_course, through: :current_selection, source: :low_course

  validates :first_name, :last_name, presence: true

  %i[top mid low].each do |priority|
    define_method(:"current_#{priority}_course=") do |course|
      (current_selection || build_current_selection(poll: current_poll)).public_send(:"#{priority}_course=", course)
    end
  end

end
