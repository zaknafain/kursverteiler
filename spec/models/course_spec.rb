# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build(:course) }

  context 'validations' do
    it 'validates presence of title' do
      expect(course).to be_valid

      course.title = nil

      expect(course).to be_invalid
      expect(course.errors[:title]).to be_present

      course.title = ''

      expect(course).to be_invalid
      expect(course.errors[:title]).to be_present
    end

    it 'validates presence of poll' do
      expect(course).to be_valid

      course.poll = nil

      expect(course).to be_invalid
      expect(course.errors[:poll]).to be_present
    end

    it 'validates presence of minimum' do
      expect(course).to be_valid

      course.minimum = nil

      expect(course).to be_invalid
      expect(course.errors[:minimum]).to be_present
    end

    it 'validates minimum to be between 0 and 100' do
      course.maximum = 99
      expect(course).to be_valid

      course.minimum = 0

      expect(course).to be_invalid
      expect(course.errors[:minimum]).to be_present

      course.minimum = 1

      expect(course).to be_valid

      course.minimum = 99

      expect(course).to be_valid

      course.minimum = 100

      expect(course).to be_invalid
      expect(course.errors[:minimum]).to be_present
    end

    it 'validates presence of maximum' do
      expect(course).to be_valid

      course.maximum = nil

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present
    end

    it 'validates maximum to be between 0 and 100' do
      course.minimum = 1
      expect(course).to be_valid

      course.maximum = 0

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present

      course.maximum = 1

      expect(course).to be_valid

      course.maximum = 99

      expect(course).to be_valid

      course.maximum = 100

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present
    end

    it 'validates maximum to be greater than minimum' do
      expect(course).to be_valid

      course.minimum = course.maximum + 1

      expect(course).to be_invalid
      expect(course.errors[:maximum]).to be_present
      expect(course.errors[:minimum]).to be_present
    end
  end
end
