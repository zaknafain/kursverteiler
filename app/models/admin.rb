# frozen_string_literal: true

# Database Model for the Administrators. Hence they are no students, they live in their own table.
# For student users see Student class.
class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
