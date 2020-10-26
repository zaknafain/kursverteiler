# frozen_string_literal: true

# RailsAdmin configuration for Admin Model
module AdminAdministration
  extend ActiveSupport::Concern

  def to_pretty_value
    "#{first_name} #{last_name} (#{email})"
  end

  included do
    rails_admin do
      weight 0
      field :email
      field :first_name
      field :last_name

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
