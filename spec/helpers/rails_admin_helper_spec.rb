# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsAdminHelper, type: :helper do
  describe '#student_count_to_course_class' do
    let(:course) { build(:course) }

    it "returns 'course__empty' when given count is zero" do
      expect(helper.student_count_to_course_class(0, course)).to eq('course__empty')
    end

    it "returns 'course__too-low' when given count is below minimum" do
      expect(helper.student_count_to_course_class(course.minimum - 1, course)).to eq('course__too-low')
    end

    it "returns 'course__good' when given count is between or equal minimum and/or maximum" do
      expect(helper.student_count_to_course_class(course.minimum, course)).to eq('course__good')
      expect(helper.student_count_to_course_class(course.maximum, course)).to eq('course__good')
    end

    it "returns 'course__too-many' when given count is greater than maximum" do
      expect(helper.student_count_to_course_class(course.maximum + 1, course)).to eq('course__too-many')
    end
  end

  describe '#selection_color_class_by' do
    let(:selection) { create(:selection) }
    let(:student)   { selection.student }
    let(:poll)      { selection.poll }

    %i[top mid low].each do |priority|
      it "returns '#{priority}-indicator' if there is a #{priority} selection present for the student and poll" do
        expect(helper.selection_color_class_by(student, poll, priority)).to eq("#{priority}-indicator")
      end

      it "returns 'missing-indicator' if there is no #{priority} selection present for the student and poll" do
        selection.update!(top_course: nil, mid_course: nil, low_course: nil)

        expect(helper.selection_color_class_by(student, poll, priority)).to eq('missing-indicator')
      end

      it "returns 'missing-indicator' if there is no selection at all for the student and poll" do
        selection.destroy!

        expect(helper.selection_color_class_by(student, poll, priority)).to eq('missing-indicator')
      end
    end
  end

  describe '#selection_icon_class_by' do
    let(:selection) { create(:selection) }
    let(:student)   { selection.student }
    let(:poll)      { selection.poll }

    %i[top mid low].each do |priority|
      it "returns 'icon-ok-sign' if there is a #{priority} selection present for the student and poll" do
        expect(helper.selection_icon_class_by(student, poll, priority)).to eq('icon-ok-sign')
      end

      it "returns 'icon-remove-circle' if there is no #{priority} selection present for the student and poll" do
        selection.update!(top_course: nil, mid_course: nil, low_course: nil)

        expect(helper.selection_icon_class_by(student, poll, priority)).to eq('icon-remove-circle')
      end

      it "returns 'icon-remove-circle' if there is no selection at all for the student and poll" do
        selection.destroy!

        expect(helper.selection_icon_class_by(student, poll, priority)).to eq('icon-remove-circle')
      end
    end
  end

  describe '#selection_icon_by' do
    let(:dummy_class) { 'Super Klasse' }
    let(:args)        { %i[student poll top] }

    before(:each) do
      allow(helper).to receive(:selection_icon_class_by).with(*args).and_return(dummy_class)
    end

    it 'returns an i tag' do
      expect(helper.selection_icon_by(*args)).to start_with('<i ')
      expect(helper.selection_icon_by(*args)).to end_with('</i>')
    end

    it 'calls selection_icon_class_by and uses it as class' do
      expect(helper.selection_icon_by(*args)).to include("class=\"#{dummy_class}\"")
    end
  end

  describe '#selection_indicator_by' do
    let(:dummy_icon)  { '<i>Hello Icon</i>'.html_safe }
    let(:dummy_class) { 'Super Klasse' }
    let(:args)        { %i[student poll top] }

    before(:each) do
      allow(helper).to receive(:selection_icon_by).with(*args).and_return(dummy_icon)
      allow(helper).to receive(:selection_color_class_by).with(*args).and_return(dummy_class)
    end

    it 'returns a div tag' do
      expect(helper.selection_indicator_by(*args)).to start_with('<div ')
      expect(helper.selection_indicator_by(*args)).to end_with('</div>')
    end

    it 'calls selection_icon_by and uses it as content' do
      expect(helper.selection_indicator_by(*args)).to include(dummy_icon)
    end

    it 'calls selection_color_class_by and uses it as class adding "selection-indicator"' do
      expect(helper.selection_indicator_by(*args)).to include("class=\"selection-indicator #{dummy_class}\"")
    end
  end

  describe '#distribution_indicator_by' do
    let(:dummy_top_indicator) { '<span>Top Indicator</span>'.html_safe }
    let(:dummy_mid_indicator) { '<span>Mid Indicator</span>'.html_safe }
    let(:dummy_low_indicator) { '<span>Low Indicator</span>'.html_safe }
    let(:top_args)            { %i[student poll top] }
    let(:mid_args)            { %i[student poll mid] }
    let(:low_args)            { %i[student poll low] }

    before(:each) do
      allow(helper).to receive(:selection_indicator_by).with(*top_args).and_return(dummy_top_indicator)
      allow(helper).to receive(:selection_indicator_by).with(*mid_args).and_return(dummy_mid_indicator)
      allow(helper).to receive(:selection_indicator_by).with(*low_args).and_return(dummy_low_indicator)
    end

    it 'concats the three indicator tags to the output_buffer' do
      helper.distribution_indicator_by(:student, :poll)
      expect(helper.output_buffer).to start_with('<span>')
      expect(helper.output_buffer).to end_with('</span>')
      expect(helper.output_buffer).to include('</span><span>').twice
    end
  end

  describe '#classes_for' do
    let(:course) { create(:course) }

    it 'returns "course" in any case' do
      expect(helper.classes_for(course)).to include('course')
    end

    it 'returns also "course__guaranteed" if guaranteed is true' do
      course.update!(guaranteed: true)

      expect(helper.classes_for(course)).to eq('course course__guaranteed')
    end

    it 'returns also the return value of student_count_to_course_class' do
      allow(helper).to receive(:student_count_to_course_class).and_return('KLASSE')

      expect(helper.classes_for(course)).to eq('course KLASSE')
    end
  end
end
