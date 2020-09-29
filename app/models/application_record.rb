# frozen_string_literal: true

# Main ActiveRecord class for inheritance
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
