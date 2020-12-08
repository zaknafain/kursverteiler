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
      it "returns 'icon-ok-sign' if the #{priority} selection and distribution matches for the student" do
        student.courses << selection.send("#{priority}_course")

        expect(helper.selection_icon_class_by(student, poll, priority)).to eq('icon-ok-sign')
      end

      it "returns 'icon-remove' if the #{priority} selection does not match the distribution for the student" do
        course = create(:course, poll: poll)
        student.courses << course

        expect(helper.selection_icon_class_by(student, poll, priority)).to eq('icon-remove')
      end

      it "returns 'icon-remove' if the #{priority} selection exists but no distribution for the student" do
        expect(helper.selection_icon_class_by(student, poll, priority)).to eq('icon-remove')
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

  describe '#student_distribution_data' do
    let(:selection) do
      create(:selection, poll: poll, student: student, top_course: course, mid_course: mid_course,
                         low_course: low_course)
    end
    let(:student)    { create(:student) }
    let(:course)     { create(:course) }
    let(:mid_course) { create(:course, poll: course.poll) }
    let(:low_course) { create(:course, poll: course.poll) }
    let(:poll)       { course.poll }

    it 'allways returns "selected: false" data' do
      expect(helper.student_distribution_data(student, poll)).to include({ selected: false })
    end

    it 'allways returns the student_id as data' do
      expect(helper.student_distribution_data(student, poll)).to include({ student_id: student.id })
    end

    it 'returns data with "course_id: nil" if there are no courses' do
      poll.courses = []

      expect(helper.student_distribution_data(student, poll)).to include({ course_id: nil })
    end

    it 'returns data with "course_id: nil" if the student was not distributed' do
      expect(helper.student_distribution_data(student, poll)).to include({ course_id: nil })
    end

    it 'returns data with "course_id: nil" if the student was distributed in another poll' do
      student.courses << create(:course)

      expect(helper.student_distribution_data(student, poll)).to include({ course_id: nil })
    end

    it 'returns data with the matching course_id if the student was distributed' do
      student.courses << course

      expect(helper.student_distribution_data(student, poll)).to include({ course_id: course.id })
    end

    it 'returns a top_course_id, mid_course_id and a low_course_id as nil per default' do
      expect(helper.student_distribution_data(student, poll)).to include({ top_course_id: nil })
      expect(helper.student_distribution_data(student, poll)).to include({ mid_course_id: nil })
      expect(helper.student_distribution_data(student, poll)).to include({ low_course_id: nil })
    end

    it 'returns a top_course_id, mid_course_id and a low_course_id from the selection of the student' do
      selection # init data

      expect(helper.student_distribution_data(student, poll)).to include({ top_course_id: course.id })
      expect(helper.student_distribution_data(student, poll)).to include({ mid_course_id: mid_course.id })
      expect(helper.student_distribution_data(student, poll)).to include({ low_course_id: low_course.id })
    end
  end
end
