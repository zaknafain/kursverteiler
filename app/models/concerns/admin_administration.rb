# frozen_string_literal: true

# RailsAdmin configuration for Admin Model
module AdminAdministration
  extend ActiveSupport::Concern

  included do
    rails_admin do
      field :email
      field :first_name
      field :last_name
    end
  end
end
