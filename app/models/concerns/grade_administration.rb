# frozen_string_literal: true

# RailsAdmin configuration for Grade Model
module GradeAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    name
  end

  included do
    rails_admin do
      weight 1
      field :name

      list do
        sort_by :name
        field :student_count
        field :running_poll do
          pretty_value do
            if value
              view = bindings[:view]
              url  = view.rails_admin.show_path(model_name: 'poll', id: value.id)
              view.link_to(value&.to_pretty_value, url, class: 'pjax')
            else
              '-'
            end
          end
        end
      end
      import do
        mapping_key :name
      end
    end
  end
end
