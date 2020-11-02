# frozen_string_literal: true

# RailsAdmin configuration for Poll Model
module PollAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    title
  end

  included do
    rails_admin do
      weight 2
      field :title
      field :valid_from
      field :valid_until

      list do
        sort_by :valid_from
        scopes [:running_at, nil]
        field :grades_count
      end
      %i[courses grades].each do |asso|
        show do
          field asso
        end
        edit do
          field asso do
            inline_add false
          end
        end
      end
      import do
        mapping_key :title
      end
    end
  end
end
