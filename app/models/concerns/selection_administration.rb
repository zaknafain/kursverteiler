# frozen_string_literal: true

# RailsAdmin configuration for Selection Model
module SelectionAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    I18n.t("activerecord.values.selection.priority.#{priority}")
  end

  included do
    rails_admin do
      {
        poll: [:title],
        student: %i[email first_name last_name],
        course: [:title]
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

      field :priority do
        help I18n.t('selections.form.help')
        pretty_value do
          I18n.t("activerecord.values.selection.priority.#{value}")
        end
        searchable false
        filterable false
      end

      list do
        scopes [nil, :top_priority, :medium_priority, :low_priority]
      end
      import do
        mapping_key_list %i[poll student priority]
      end
    end
  end
end
