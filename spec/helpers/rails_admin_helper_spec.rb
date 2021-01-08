# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RailsAdminHelper, type: :helper do
  describe '#student_count_to_course_class' do
    let(:course) { build(:course) }

    it "returns 'alert-info' when given count is zero" do
      expect(helper.student_count_to_course_class(0, course)).to eq('alert-info')
    end

    it "returns 'alert-warning' when given count is below minimum" do
      expect(helper.student_count_to_course_class(course.minimum - 1, course)).to eq('alert-warning')
    end

    it "returns 'alert-success' when given count is between or equal minimum and/or maximum" do
      expect(helper.student_count_to_course_class(course.minimum, course)).to eq('alert-success')
      expect(helper.student_count_to_course_class(course.maximum, course)).to eq('alert-success')
    end

    it "returns 'alert-danger' when given count is greater than maximum" do
      expect(helper.student_count_to_course_class(course.maximum + 1, course)).to eq('alert-danger')
    end
  end

  describe '#selection_color_class_by' do
    let(:selection) { create(:selection) }
    let(:student)   { selection.student }
    let(:poll)      { selection.poll }

    it 'returns text color class if there is a selection present for the student and poll' do
      expect(helper.selection_color_class_by(student, poll, :top)).to eq('text-success')
      expect(helper.selection_color_class_by(student, poll, :mid)).to eq('text-warning')
      expect(helper.selection_color_class_by(student, poll, :low)).to eq('text-danger')
    end

    %i[top mid low].each do |priority|
      it "returns 'text-muted' if there is no #{priority} selection present for the student and poll" do
        selection.update!(top_course: nil, mid_course: nil, low_course: nil)

        expect(helper.selection_color_class_by(student, poll, priority)).to eq('text-muted')
      end

      it "returns 'text-muted' if there is no selection at all for the student and poll" do
        selection.destroy!

        expect(helper.selection_color_class_by(student, poll, priority)).to eq('text-muted')
      end
    end
  end

  describe '#priority_to_indicator' do
    it 'returns text-success for top priority' do
      expect(helper.priority_to_indicator(:top)).to eq('text-success')
      expect(helper.priority_to_indicator(:mid)).to eq('text-warning')
      expect(helper.priority_to_indicator(:low)).to eq('text-danger')
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

    it 'returns "alert" in any case' do
      expect(helper.classes_for(course)).to include('alert')
    end

    it 'returns also "alert-info" if guaranteed is true' do
      course.update!(guaranteed: true)

      expect(helper.classes_for(course)).to eq('course alert alert-info')
    end

    it 'returns also the return value of student_count_to_course_class' do
      allow(helper).to receive(:student_count_to_course_class).and_return('KLASSE')

      expect(helper.classes_for(course)).to eq('course alert KLASSE')
    end
  end

  describe '#student_distribution_data' do
    let(:selection) { create(:selection) }
    let(:student)   { selection.student }
    let(:poll)      { create(:poll, courses: [selection.top_course, selection.mid_course, selection.low_course]) }

    it 'always returns the student_id as data' do
      expect(helper.student_distribution_data(student, poll)).to include({ student_id: student.id })
    end

    it 'always returns the popover toggle' do
      expect(helper.student_distribution_data(student, poll)).to include({ toggle: 'popover' })
    end

    it 'always returns the popover placement' do
      expect(helper.student_distribution_data(student, poll)).to include({ placement: 'right' })
    end

    it 'returns popover content from selection_to_html' do
      expect(helper).to receive(:selection_to_html).and_return('FOOBAR')

      expect(helper.student_distribution_data(student, poll)).to include({ content: 'FOOBAR' })
    end

    it 'returns popover content from old_courses_to_html' do
      expect(helper).to receive(:old_courses_to_html).and_return('FOOBAR')

      expect(helper.student_distribution_data(student, poll)).to include({ content: 'FOOBAR' })
    end
  end

  describe '#selection_to_html' do
    let(:selection) { create(:selection) }
    let(:poll)      { create(:poll, courses: [selection.top_course, selection.mid_course, selection.low_course]) }

    it 'returns the title of each selected course' do
      expect(helper.selection_to_html(selection, poll.courses)).to include(selection.top_course.title)
      expect(helper.selection_to_html(selection, poll.courses)).to include(selection.mid_course.title)
      expect(helper.selection_to_html(selection, poll.courses)).to include(selection.low_course.title)
    end

    it 'returns the priority of the course' do
      expect(helper.selection_to_html(selection, poll.courses)).to include(
        "#{I18n.t('students.show.prio.top')}: #{selection.top_course.title}"
      )
      expect(helper.selection_to_html(selection, poll.courses)).to include(
        "#{I18n.t('students.show.prio.mid')}: #{selection.mid_course.title}"
      )
      expect(helper.selection_to_html(selection, poll.courses)).to include(
        "#{I18n.t('students.show.prio.low')}: #{selection.low_course.title}"
      )
    end
  end

  describe '#old_courses_to_html' do
    let(:student)      { create(:student, courses: [old_course]) }
    let(:old_course)   { create(:course) }
    let(:course)       { create(:course) }
    let(:child_course) { create(:course, parent_course: old_course) }

    it 'returns an empty string if there are no old courses matching any parent of the given courses' do
      expect(helper.old_courses_to_html(student, [course])).to eq('')
    end

    it 'returns the title of the child course if the student was distributed to the parent before' do
      expect(helper.old_courses_to_html(student, [course, child_course])).to include(child_course.title)
    end

    it 'returns a warning icon for that child course' do
      expect(helper.old_courses_to_html(student, [course, child_course])).to include("<i class='icon-warning-sign'>")
      expect(helper.old_courses_to_html(student, [course])).to_not include("<i class='icon-warning-sign'>")
    end
  end

  describe '#selection_title' do
    let(:course_a) { create(:course) }
    let(:course_b) { create(:course) }

    it 'returns the title of the course with the given id' do
      expect(helper.selection_title(course_a.id, [course_a, course_b])).to eq(course_a.title)
      expect(helper.selection_title(course_b.id, [course_a, course_b])).to eq(course_b.title)
    end
  end
end
