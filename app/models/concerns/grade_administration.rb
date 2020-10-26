# frozen_string_literal: true

# RailsAdmin configuration for Grade Model
module GradeAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    name
  end

  included do
    rails_admin do
      parent EducationalProgram
      field :name
      field :educational_program do
        inline_add false
        inline_edit false
        queryable true
        searchable :name
        sortable :name
        filterable true
      end

      list do
        sort_by :name
      end
      import do
        mapping_key :name
      end
    end
  end
end
