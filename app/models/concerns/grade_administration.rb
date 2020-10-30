# frozen_string_literal: true

# RailsAdmin configuration for Grade Model
module GradeAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    name
  end

  included do
    rails_admin do
      field :name

      list do
        sort_by :name
      end
      import do
        mapping_key :name
      end
    end
  end
end
