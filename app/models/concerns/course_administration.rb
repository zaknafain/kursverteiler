# frozen_string_literal: true

# RailsAdmin configuration for Course Model
module CourseAdministration
  extend ActiveSupport::Concern

  included do
    rails_admin do
      field :title
      field :minimum
      field :maximum
      field :description
      field :teacher_name
      field :poll do
        inline_add false
        inline_edit false
      end
    end
  end
end
