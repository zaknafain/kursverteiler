# frozen_string_literal: true

# RailsAdmin configuration for Student Model
module StudentAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    "#{first_name} #{last_name} (#{email})"
  end

  included do
    rails_admin do
      parent Grade
      field :email
      field :first_name
      field :last_name
      field :grade do
        inline_add false
        inline_edit false
        queryable true
        searchable :name
        sortable :name
        filterable true
      end

      list do
        sort_by :last_name
        %i[top_selection mid_selection low_selection].each do |selection|
          field selection do
            inline_add false
            inline_edit true
            queryable false
            searchable false
            sortable false
            filterable false

            formatted_value do
              value&.course&.id
            end

            pretty_value do
              if value
                view = bindings[:view]
                url  = view.rails_admin.show_path(model_name: 'course', id: value.course_id)
                view.link_to(value&.course&.to_pretty_value, url, class: 'pjax')
              else
                '-'
              end
            end
          end
        end
      end
      edit do
        %i[password password_confirmation].each do |field_name|
          field field_name do
            default_value ''
          end
        end
      end
      import do
        mapping_key :email
        mapping_key_list [:email]
      end
    end
  end

  def before_import_save(_)
    self.password = self.password_confirmation = SecureRandom.hex unless persisted?
  end
end
