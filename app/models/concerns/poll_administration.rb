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
      field :description do
        js_location { bindings[:view].asset_pack_path 'actiontext.js' }
      end

      list do
        sort_by :valid_from
        scopes [:future, :running_at, nil]
        exclude_fields :description
        field :grades_count
      end
      show do
        field :grades
      end
      edit do
        field :grades do
          inline_add false
        end
      end
      import do
        mapping_key :title
      end
    end
  end
end
