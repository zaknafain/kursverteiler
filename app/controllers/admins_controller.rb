# frozen_string_literal: true

# Controller, that handles all pages made directly for admins.
class AdminsController < ApplicationController
  before_action :authenticate_admin!

  def distribution
    @polls = Poll.running_at(Time.zone.now)
  end

end
