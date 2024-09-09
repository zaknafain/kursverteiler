# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { build(:admin) }

  describe 'validations' do
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

    it 'validates coordinator to be true or false' do
      expect(admin).to be_valid

      admin.coordinator = nil

      expect(admin).to be_invalid
      expect(admin.errors[:coordinator]).to be_present

      admin.coordinator = true

      expect(admin).to be_valid
    end
  end

  describe '#full_name' do
    it 'returns the first name and the last name seperated by a space' do
      expect(admin.full_name).to eq("#{admin.first_name} #{admin.last_name}")
    end
  end

  describe '#official_name' do
    it 'returns the last name and the first name seperated by comma and space' do
      expect(admin.official_name).to eq("#{admin.last_name}, #{admin.first_name}")
    end
  end

  describe 'scopes' do
    describe '::coordinators' do
      it 'returns admins with coordinator true' do
        coordinator = create(:admin, coordinator: true)
        admin = create(:admin, coordinator: false)

        expect(described_class.coordinators).to     include(coordinator)
        expect(described_class.coordinators).not_to include(admin)
      end
    end
  end
end
