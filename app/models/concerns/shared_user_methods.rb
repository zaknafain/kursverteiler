# frozen_string_literal: true

# Methods that are the same for Students and Admins
module SharedUserMethods
  def self.included(klass)
    klass.instance_eval do
      # Include default devise modules. Others available are:
      # :registerable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
      devise :database_authenticatable, :recoverable, :rememberable, :validatable

      validates :first_name, :last_name, presence: true
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def official_name
    "#{last_name}, #{first_name}"
  end
end
