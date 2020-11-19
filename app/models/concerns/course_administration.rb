# frozen_string_literal: true

# RailsAdmin configuration for Course Model
module CourseAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    title
  end

  included do
    rails_admin do
      parent Poll
      field :title
      field :focus_areas
      %i[minimum maximum].each do |attribute|
        field attribute do
          searchable false
          sortable false
        end
      end
      field :description do
        searchable false
        sortable false
        js_location { bindings[:view].asset_pack_path 'actiontext.js' }
      end
      field :variants
      field :teacher_name
      field :poll do
        inline_add false
        inline_edit false
        queryable true
        searchable [:title]
        sortable :title
      end

      list do
        sort_by :title
        scopes [:current, nil]
        exclude_fields :focus_areas, :description, :variants, :teacher_name
      end
      import do
        mapping_key :title
      end
    end
  end
end
