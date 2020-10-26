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
      end
      import do
        mapping_key :email
      end
    end
  end

  def before_import_save(_)
    self.password = self.password_confirmation = SecureRandom.hex unless persisted?
  end
end
