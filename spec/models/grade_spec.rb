require 'rails_helper'

RSpec.describe Grade, type: :model do
  let(:grade) { build(:grade) }

  context 'relations' do
    let(:student) { create(:student) }
    let!(:grade)  { student.grade }

    it 'destroys all its students on deletion' do
      expect { grade.destroy }.to change(Student, :count).by(-1)
    end
  end

  context 'validations' do
    it 'uniqueness of name' do
      expect(grade).to be_valid

      create(:grade, name: grade.name)

      expect(grade).to be_invalid
      expect(grade.errors[:name]).to be_present
    end

    it 'uniqueness of name case insensitive' do
      expect(grade).to be_valid

      create(:grade, name: grade.name.upcase)

      expect(grade).to be_invalid
      expect(grade.errors[:name]).to be_present
    end
  end
end
