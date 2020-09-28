# frozen_string_literal: true

# RailsAdmin configuration for Student Model
module StudentAdministration
  extend ActiveSupport::Concern

  included do
    rails_admin do
      field :email
      field :first_name
      field :last_name

      import do
        mapping_key :email
      end
    end
  end

  def before_import_save(_)
    self.password = self.password_confirmation = SecureRandom.hex unless persisted?
  end
end
