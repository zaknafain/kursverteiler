# frozen_string_literal: true

# Controller, that handles all simple admin pages.
class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def home; end
end
