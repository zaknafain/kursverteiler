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

  describe '#course_classes' do
    it 'returns a string that allways contains "course"' do
      expect(helper.course_classes(nil, false).split).to include('course')
    end

    it 'returns a string including "course__selected" if there is any prio selected' do
      expect(helper.course_classes(nil, false).split).to_not include('course__selected')
      %i[top mid low].each do |prio|
        expect(helper.course_classes(prio, false).split).to include('course__selected')
      end
    end

    %i[top mid low].each do |prio|
      it "returns a string including 'course__selected--#{prio} if #{prio} is given as priority" do
        expect(helper.course_classes(prio, false).split).to include("course__selected--#{prio}")
      end
    end

    it 'returns a string including "course__disabled" if disabled is true' do
      expect(helper.course_classes(nil, false).split).to_not include('course__disabled')
      expect(helper.course_classes(nil, true).split).to      include('course__disabled')
    end
  end

  describe '#course_prio_classes' do
    it 'returns a string that allways contains "course-priority--container"' do
      expect(helper.course_prio_classes(nil, false, false, false).split).to include('course-priority--container')
    end

    it 'returns a string including "course-priority--container__selected" if selected is true' do
      expect(
        helper.course_prio_classes(nil, false, false, false).split
      ).to_not include('course-priority--container__selected')
      expect(
        helper.course_prio_classes(nil, true, false, false).split
      ).to include('course-priority--container__selected')
    end

    %i[top mid low].each do |prio|
      it "returns a string including 'course-priority--container__#{prio} if #{prio} is given as priority" do
        expect(
          helper.course_prio_classes(prio, false, false, false).split
        ).to include("course-priority--container__#{prio}")
      end
    end

    it 'returns a string including "course-priority--container__disabled" if disabled is true' do
      expect(
        helper.course_prio_classes(nil, false, false, false).split
      ).to_not include('course-priority--container__disabled')
      expect(
        helper.course_prio_classes(nil, false, false, true).split
      ).to include('course-priority--container__disabled')
    end

    it 'returns a string including "course-priority--container__disabled" if guaranteed is true and prio is not top' do
      expect(
        helper.course_prio_classes(nil, false, true, false).split
      ).to_not include('course-priority--container__disabled')
      expect(
        helper.course_prio_classes(:mid, false, true, false).split
      ).to include('course-priority--container__disabled')
      expect(
        helper.course_prio_classes(:low, false, true, false).split
      ).to include('course-priority--container__disabled')
      expect(
        helper.course_prio_classes(:top, false, true, false).split
      ).to_not include('course-priority--container__disabled')
    end
  end
end
