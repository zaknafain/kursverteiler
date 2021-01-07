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
      expect(helper.course_card_classes(nil, false)).to include('card')
      expect(helper.course_card_classes(nil, false)).to include('h-100')
    end

    it 'returns "bg-light" if there is no priority selected' do
      expect(helper.course_card_classes(nil, false)).to include('bg-light')
    end

    it 'returns "text-muted" if the course was disabled' do
      expect(helper.course_card_classes(nil, true)).to include('text-muted')
    end

    it 'returns "bg-success" if the selected priority is :top' do
      expect(helper.course_card_classes(:top, false)).to include('bg-success')
    end

    it 'returns "bg-warning" if the selected priority is :mid' do
      expect(helper.course_card_classes(:mid, false)).to include('bg-warning')
    end

    it 'returns "bg-danger" if the selected priority is :low' do
      expect(helper.course_card_classes(:low, false)).to include('bg-danger')
    end
  end

  describe '#priority_button' do
    let(:course) { build(:course) }

    it 'returns a button tag' do
      expect(helper.priority_button(course, :top, nil, false)).to start_with('<button')
      expect(helper.priority_button(course, :top, nil, false)).to end_with('</button>')
    end

    it 'returns a button with a button type' do
      expect(helper.priority_button(course, :top, nil, false)).to include('type="button"')
    end

    it 'returns a button with a text matching the given priority' do
      expect(helper.priority_button(course, :top, nil, false)).to include(">#{I18n.t('students.show.prio.top')}<")
      expect(helper.priority_button(course, :mid, nil, false)).to include(">#{I18n.t('students.show.prio.mid')}<")
      expect(helper.priority_button(course, :low, nil, false)).to include(">#{I18n.t('students.show.prio.low')}<")
    end

    it 'returns a button with a disabled flag if needed' do
      expect(helper.priority_button(course, :top, nil, false)).to_not include('disabled')
      expect(helper.priority_button(course, :top, nil, true)).to      include('disabled')
    end

    it 'returns a button with the classes of the #priority_button_classes method' do
      expect(helper).to receive(:priority_button_classes).and_return('foo bar')
      expect(helper.priority_button(course, :top, nil, false)).to include('class="foo bar"')
    end

    it 'returns a button with the data attributes of the #priority_button_data method' do
      expect(helper).to receive(:priority_button_data).and_return({ foo: :bar, bam: 'Boom' }).twice
      expect(helper.priority_button(course, :top, nil, false)).to include('data-foo="bar"')
      expect(helper.priority_button(course, :top, nil, false)).to include('data-bam="Boom"')
    end
  end

  describe '#priority_button_classes' do
    it 'returns a string always including "btn"' do
      classes = helper.priority_button_classes(:top, false, false).split

      expect(helper.priority_button_classes(:top, false, false).class).to eq(String)
      expect(classes).to include('btn')
    end

    it 'returns "btn-success" for top priority' do
      classes = helper.priority_button_classes(:top, false, false).split

      expect(classes).to     include('btn-success')
      expect(classes).to_not include('btn-light')
      expect(classes).to_not include('btn-warning')
      expect(classes).to_not include('btn-danger')
    end

    it 'returns "btn-warning" for mid priority' do
      classes = helper.priority_button_classes(:mid, false, false).split

      expect(classes).to     include('btn-warning')
      expect(classes).to_not include('btn-light')
      expect(classes).to_not include('btn-success')
      expect(classes).to_not include('btn-danger')
    end

    it 'returns "btn-danger" for low priority' do
      classes = helper.priority_button_classes(:low, false, false).split

      expect(classes).to     include('btn-danger')
      expect(classes).to_not include('btn-light')
      expect(classes).to_not include('btn-success')
      expect(classes).to_not include('btn-warning')
    end

    it 'returns "btn-light" is disabled is true' do
      expect(helper.priority_button_classes(:top, true, false).split).to     include('btn-light')
      expect(helper.priority_button_classes(:top, true, false).split).to_not include('btn-success')
      expect(helper.priority_button_classes(:mid, true, false).split).to_not include('btn-warning')
      expect(helper.priority_button_classes(:low, true, false).split).to_not include('btn-danger')
    end

    it 'returns "course-priority--" with the priority as ending' do
      expect(helper.priority_button_classes(:top, false, false).split).to include('course-priority--top')
      expect(helper.priority_button_classes(:mid, false, false).split).to include('course-priority--mid')
      expect(helper.priority_button_classes(:low, false, false).split).to include('course-priority--low')
    end

    it 'returns "active border border-dark" if selected is true' do
      expect(helper.priority_button_classes(:top, false, true).split).to include('active')
      expect(helper.priority_button_classes(:mid, false, true).split).to include('active')
      expect(helper.priority_button_classes(:low, false, true).split).to include('active')
      expect(helper.priority_button_classes(:top, false, true).split).to include('border')
      expect(helper.priority_button_classes(:mid, false, true).split).to include('border')
      expect(helper.priority_button_classes(:low, false, true).split).to include('border')
      expect(helper.priority_button_classes(:top, false, true).split).to include('border-dark')
      expect(helper.priority_button_classes(:mid, false, true).split).to include('border-dark')
      expect(helper.priority_button_classes(:low, false, true).split).to include('border-dark')
    end
  end

  describe '#priority_button_data' do
    let(:course) { build(:course) }

    it 'returns a hash' do
      expect(helper.priority_button_data(course, :top, nil).class).to eq(Hash)
    end

    it 'returns the key course_id with the id value of the course' do
      course.save!

      expect(helper.priority_button_data(course, :top, nil)[:course_id]).to eq(course.id)
    end

    it 'returns the key priority with the given priority value' do
      expect(helper.priority_button_data(course, :top, nil)[:priority]).to eq(:top)
      expect(helper.priority_button_data(course, :mid, nil)[:priority]).to eq(:mid)
      expect(helper.priority_button_data(course, :low, nil)[:priority]).to eq(:low)
    end

    it 'returns the key selected_prio with the given selected_prio value' do
      expect(helper.priority_button_data(course, :top, nil)[:selected_prio]).to  eq(nil)
      expect(helper.priority_button_data(course, :top, :top)[:selected_prio]).to eq(:top)
      expect(helper.priority_button_data(course, :top, :mid)[:selected_prio]).to eq(:mid)
      expect(helper.priority_button_data(course, :top, :low)[:selected_prio]).to eq(:low)
    end

    it 'returns the key guaranteed with the given course guaranteed attribute value' do
      expect(helper.priority_button_data(course, :top, nil)[:guaranteed]).to eq(course.guaranteed?)

      course.guaranteed = !course.guaranteed

      expect(helper.priority_button_data(course, :top, nil)[:guaranteed]).to eq(course.guaranteed?)
    end
  end

  describe '#priority_to_bootstrap' do
    it 'returns "success" for priority :top' do
      expect(helper.priority_to_bootstrap(:top)).to eq('success')
    end

    it 'returns "warning" for priority :mid' do
      expect(helper.priority_to_bootstrap(:mid)).to eq('warning')
    end
    it 'returns "danger" for priority :low' do
      expect(helper.priority_to_bootstrap(:low)).to eq('danger')
    end
  end
end
