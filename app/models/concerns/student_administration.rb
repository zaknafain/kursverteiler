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
      edit do
        %i[password password_confirmation].each do |field_name|
          field field_name do
            default_value ''
          end
        end
        %i[top mid low].each do |priority|
          field :"current_#{priority}_course" do
            visible { bindings[:object].current_poll.present? }
            inline_add false
            inline_edit false
            associated_collection_cache_all false
            associated_collection_scope do
              student = bindings[:object]
              proc do |scope|
                scope.where(poll: student.current_poll.id).order(:title)
              end
            end
          end
        end
      end
      import do
        mapping_key :email
        mapping_key_list [:email]
      end
    end

    def self.before_import_find(record)
      record[:email] = record[:email]&.downcase
    end
  end

  def before_import_save(_)
    self.password = self.password_confirmation = Devise.friendly_token(50) unless persisted?
  end

  %i[top mid low].each do |priority|
    define_method(:"current_#{priority}_course_id") do
      public_send(:"current_#{priority}_course")&.id
    end

    define_method(:"current_#{priority}_course_id=") do |id|
      public_send(:"current_#{priority}_course=", current_poll.courses.find_by(id: id))
    end
  end
end
