# frozen_string_literal: true

# RailsAdmin configuration for Poll Model
module PollAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    title
  end

  included do
    rails_admin do
      parent EducationalProgram
      field :title
      field :valid_from
      field :valid_until
      field :educational_program do
        inline_add false
        inline_edit false
        queryable true
        searchable :name
        sortable :name
        filterable true
      end

      list do
        sort_by :valid_from
        scopes [:running_at, nil]
      end
      import do
        mapping_key :title
      end
    end
  end
end
