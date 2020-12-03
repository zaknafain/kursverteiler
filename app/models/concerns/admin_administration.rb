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
      edit do
        %i[password password_confirmation].each do |field_name|
          field field_name do
            default_value ''
          end
        end
      end
    end
  end

  def before_import_save(_)
    self.password = self.password_confirmation = Devise.friendly_token(50) unless persisted?
  end
end
