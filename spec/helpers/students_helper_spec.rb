# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsHelper, type: :helper do
  describe '#flash_classes' do
    it 'returns always "alert"' do
      expect(helper.flash_classes(nil)).to include('alert')
    end

    it 'returns "alert-danger" for error flashes' do
      expect(helper.flash_classes(:error)).to include('alert-danger')
    end

    it 'returns "alert-success" for success flashes' do
      expect(helper.flash_classes(:success)).to include('alert-success')
    end

    it 'returns "alert-info" for notice flashes' do
      expect(helper.flash_classes(:notice)).to include('alert-info')
    end
  end
end
