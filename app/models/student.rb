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

  validates :first_name, :last_name, presence: true
end
