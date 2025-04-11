# frozen_string_literal: true

# Database Model for the Administrators. Hence they are no students, they live in their own table.
# For student users see Student class.
class Admin < ApplicationRecord
  include SharedUserMethods

  validates :coordinator, inclusion: { in: [true, false] }

  scope :coordinators, -> { where(coordinator: true) }

end
