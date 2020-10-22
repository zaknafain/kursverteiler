# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationalProgram, type: :model do
  let(:program) { build(:educational_program) }

  context 'relations' do
    let(:poll)                 { create(:poll) }
    let!(:educational_program) { poll.educational_program }

    it 'destroys all its polls on deletion' do
      expect { educational_program.destroy }.to change(Poll, :count).by(-1)
    end
  end

  context 'validations' do
    it 'uniqueness of name' do
      expect(program).to be_valid

      create(:educational_program, name: program.name)

      expect(program).to be_invalid
      expect(program.errors[:name]).to be_present
    end

    it 'uniqueness of name case insensitive' do
      expect(program).to be_valid

      create(:educational_program, name: program.name.upcase)

      expect(program).to be_invalid
      expect(program.errors[:name]).to be_present
    end
  end
end
