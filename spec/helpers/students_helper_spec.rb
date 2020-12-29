# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StudentsHelper, type: :helper do
  describe '#flash_classes' do
    it 'returns always "alert"' do
      expect(helper.flash_classes(:foo)).to include('alert')
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

  describe '#course_card_classes' do
    it 'returns always "card h-100"' do
      expect(helper.course_card_classes(nil)).to include('card')
      expect(helper.course_card_classes(nil)).to include('h-100')
    end

    it 'returns "bg-light" if there is no priority selected' do
      expect(helper.course_card_classes(nil)).to include('bg-light')
    end

    it 'returns "bg-success" if the selected priority is :top' do
      expect(helper.course_card_classes(:top)).to include('bg-success')
    end

    it 'returns "bg-warning" if the selected priority is :mid' do
      expect(helper.course_card_classes(:mid)).to include('bg-warning')
    end

    it 'returns "bg-danger" if the selected priority is :low' do
      expect(helper.course_card_classes(:low)).to include('bg-danger')
    end
  end
end
