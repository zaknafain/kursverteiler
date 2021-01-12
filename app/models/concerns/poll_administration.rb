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
        field :students_without_selection do
          pretty_value do
            if value
              view = bindings[:view]
              grade_id = nil
              links = value.sort_by { |s| [s.grade_id] }.each_with_object([]) do |student, link_list|
                url = view.rails_admin.show_path(model_name: 'student', id: student.id)

                link_list << view.tag.br if student.grade_id != grade_id && grade_id.present?
                link_list << view.tag.span("#{student.grade.name}: ") if student.grade_id != grade_id
                link_list << view.link_to(student&.to_pretty_value, url, class: 'pjax')
                link_list << ', '
                grade_id = student.grade_id
              end
              view.safe_join(links)
            else
              '-'
            end
          end
        end
      end
      edit do
        field :grades do
          inline_add false
        end
      end
    end
  end
end
