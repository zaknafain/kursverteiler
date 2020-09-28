# frozen_string_literal: true

# RailsAdmin configuration for Poll Model
module PollAdministration
  extend ActiveSupport::Concern

  included do
    rails_admin do
      field :title
      field :valid_from
      field :valid_until
    end
  end
end
