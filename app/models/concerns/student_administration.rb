# frozen_string_literal: true

# RailsAdmin configuration for Student Model
module StudentAdministration
  extend ActiveSupport::Concern

  included do
    rails_admin do
      field :email
      field :first_name
      field :last_name
    end
  end
end
