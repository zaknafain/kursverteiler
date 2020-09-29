# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { build(:admin) }

  context 'validations' do
    it 'validates presence of first_name' do
      expect(admin).to be_valid

      admin.first_name = nil

      expect(admin).to be_invalid
      expect(admin.errors[:first_name]).to be_present

      admin.first_name = ''

      expect(admin).to be_invalid
      expect(admin.errors[:first_name]).to be_present
    end

    it 'validates presence of last_name' do
      expect(admin).to be_valid

      admin.last_name = nil

      expect(admin).to be_invalid
      expect(admin.errors[:last_name]).to be_present

      admin.last_name = ''

      expect(admin).to be_invalid
      expect(admin.errors[:last_name]).to be_present
    end
  end
end
