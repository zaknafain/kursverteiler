# frozen_string_literal: true

# RailsAdmin configuration for Selection Model
module SelectionAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    "#{top_course.to_pretty_value || '-'} #{mid_course.to_pretty_value || '-'} #{low_course.to_pretty_value || '-'}"
  end

  included do
    rails_admin do
      weight 3
      {
        poll: [:title],
        student: %i[email first_name last_name],
        top_course: [:title],
        mid_course: [:title],
        low_course: [:title]
      }.each do |association, searchables|
        field association do
          inline_add false
          inline_edit false
          queryable true
          searchable searchables
          sortable searchables.last
          filterable true
        end
      end

      list do
        scopes [:current, nil]
      end
      import do
        mapping_key_list %i[poll student]
      end
    end
  end
end
