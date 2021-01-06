# frozen_string_literal: true

# Database Model for the Administrators. Hence they are no students, they live in their own table.
# For student users see Student class.
class Admin < ApplicationRecord
  include AdminAdministration
  include SharedUserMethods

  scope :koordinators_only, lambda {
    backup_email = Rails.application.credentials.dig(:admin, :email)

    where.not(email: backup_email)
  }

end
