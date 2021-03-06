# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { build(:student) }

  context 'relations' do
    context 'grade' do
      it 'responds to grade' do
        expect(student).to respond_to(:grade)
      end
    end

    context 'selections' do
      let!(:selection)     { create(:selection, student: student) }
      let!(:old_selection) { create(:selection, student: student, poll: old_poll) }
      let(:old_poll)       { create(:poll, :ended) }

      it 'responds to selections' do
        expect(student).to respond_to(:selections)
      end

      it 'destroys all its selections on deletion' do
        expect { student.destroy }.to change(Selection, :count).by(-2)
      end

      it 'has one current selection' do
        expect(student.selections.count).to be(2)
        expect(student.selections.pluck(:id)).to include(selection.id)
        expect(student.selections.pluck(:id)).to include(old_selection.id)

        expect(student.current_selection.id).to be(selection.id)
      end
    end

    context 'current courses' do
      let!(:selection) { create(:selection, student: student) }

      it 'has a current top course' do
        expect(student).to respond_to(:current_top_course)
      end

      it 'has a current top course through current selection' do
        expect(student.current_top_course.id).to be(selection.top_course.id)
      end

      it 'has a current mid course' do
        expect(student).to respond_to(:current_mid_course)
      end

      it 'has a current mid course through current selection' do
        expect(student.current_mid_course.id).to be(selection.mid_course.id)
      end

      it 'has a current low course' do
        expect(student).to respond_to(:current_low_course)
      end

      it 'has a current low course through current selection' do
        expect(student.current_low_course.id).to be(selection.low_course.id)
      end

      it 'returns nil if there is no current selection' do
        student = build(:student)

        expect(student.current_top_course).to be_nil
      end

      it 'returns nil if the selection has no course' do
        selection.update(low_course: nil)

        expect(student.current_low_course).to be_nil
      end

      it 'can be assigned and saved' do
        expect(student.current_top_course.id).to be(selection.top_course.id)

        expect do
          student.current_top_course = selection.mid_course
          student.current_mid_course = selection.low_course
          student.current_low_course = selection.top_course
          student.save!
        end.to(change { selection.reload.top_course.id })
      end

      it 'will not destroy the selection if nil is assigned' do
        expect(student.current_selection.id).to_not be_nil

        expect do
          student.current_top_course = nil
          student.current_mid_course = nil
          student.current_low_course = nil
          student.save!
        end.to_not(change { selection.reload.id })
      end
    end

    context 'current poll' do
      let!(:poll) { create(:poll, grades: [student.grade]) }

      it 'has one current poll' do
        expect(student).to respond_to(:current_poll)
      end

      it 'has one current poll through grades' do
        student.save!

        expect(student.current_poll.id).to be(poll.id)
      end
    end

    context 'courses_students' do
      let(:course) { create(:course) }

      it 'has many courses students' do
        expect(student).to respond_to(:courses_students)
      end

      it 'destroys all courses students on deletion' do
        student.save!
        student.courses << course

        expect { student.destroy }.to change(CoursesStudent, :count).by(-1)
      end
    end

    context 'courses' do
      let(:course) { create(:course) }

      it 'has many courses' do
        expect(student).to respond_to(:courses)
      end

      it 'has many courses through courses students' do
        student.save!
        expect(student.courses).to be_empty

        student.courses_students.create!(course: course)

        expect(student.courses).to_not be_empty
        expect(student.courses.map(&:id)).to eq([course.id])
      end
    end
  end

  context 'validations' do
    it 'validates presence of grade' do
      expect(student).to be_valid

      student.grade = nil

      expect(student).to be_invalid
      expect(student.errors[:grade]).to be_present
    end

    it 'validates absence of grade if paused_at is set' do
      expect(student).to be_valid

      student.grade = nil

      expect(student).to be_invalid
      expect(student.errors[:grade]).to be_present

      student.paused_at = Time.zone.now

      expect(student).to be_valid
    end

    it 'is not valid if grade and paused_at are both set' do
      expect(student).to be_valid

      student.paused_at = Time.zone.now

      expect(student).to be_invalid
      expect(student.errors[:grade]).to be_present
    end

    it 'validates presence of first_name' do
      expect(student).to be_valid

      student.first_name = nil

      expect(student).to be_invalid
      expect(student.errors[:first_name]).to be_present

      student.first_name = ''

      expect(student).to be_invalid
      expect(student.errors[:first_name]).to be_present
    end

    it 'validates presence of last_name' do
      expect(student).to be_valid

      student.last_name = nil

      expect(student).to be_invalid
      expect(student.errors[:last_name]).to be_present

      student.last_name = ''

      expect(student).to be_invalid
      expect(student.errors[:last_name]).to be_present
    end

    it 'validates presence of email' do
      expect(student).to be_valid

      student.email = nil

      expect(student).to be_invalid
      expect(student.errors[:email]).to be_present

      student.email = ''

      expect(student).to be_invalid
      expect(student.errors[:email]).to be_present
    end
  end

  context 'scopes' do
    context 'paused' do
      let!(:student)        { create(:student) }
      let!(:paused_student) { create(:student, :paused) }

      it 'returns all students wich are paused' do
        expect(Student.paused.pluck(:id)).to eq([paused_student.id])

        new_student = create(:student, :paused)

        expect(Student.paused.pluck(:id)).to include(new_student.id)
      end
    end

    context 'not_distributed_in' do
      let(:course)   { create(:course) }
      let(:poll)     { course.poll }
      let(:grade)    { create(:grade, polls: [poll]) }
      let!(:student) { create(:student, grade: grade) }

      it 'returns all students not distributed in the given poll' do
        expect(Student.not_distributed_in(poll.id).pluck(:id)).to eq([student.id])

        new_student = create(:student, grade: grade)

        expect(Student.not_distributed_in(poll.id).pluck(:id)).to include(new_student.id)

        new_student.courses << course

        expect(Student.not_distributed_in(poll.id).pluck(:id)).to eq([student.id])
      end
    end

    context 'can_vote_on' do
      let(:poll)       { create(:poll) }
      let(:grade)      { create(:grade, polls: [poll]) }
      let!(:student_a) { create(:student, grade: grade) }
      let!(:student_b) { create(:student) }

      it 'returns all students connected to the poll via the grades' do
        expect(Student.can_vote_on(poll.id).pluck(:id)).to eq([student_a.id])

        student_b.update!(grade: grade)

        expect(Student.can_vote_on(poll.id).pluck(:id)).to include(student_a.id)
        expect(Student.can_vote_on(poll.id).pluck(:id)).to include(student_b.id)
      end
    end

    context 'distributed_in' do
      let(:course)     { create(:course) }
      let(:poll)       { course.poll }
      let(:grade)      { create(:grade, polls: [poll]) }
      let!(:student_a) { create(:student, grade: grade) }
      let!(:student_b) { create(:student, grade: grade) }

      it 'returns all students allready distributed' do
        expect(Student.distributed_in(poll.id).pluck(:id)).to be_empty

        student_a.courses << course

        expect(Student.distributed_in(poll.id).pluck(:id)).to eq([student_a.id])

        student_b.courses << course

        expect(Student.can_vote_on(poll.id).pluck(:id)).to include(student_a.id)
        expect(Student.can_vote_on(poll.id).pluck(:id)).to include(student_b.id)
      end
    end
  end

  context 'hooks' do
    it 'responds to paused_flag' do
      expect(student).to respond_to(:paused_flag)
    end

    it 'calls the set_paused_at method before validation' do
      student.grade = nil

      expect(student).to be_invalid

      student.paused_flag = '1'

      expect(student).to receive(:set_paused_at).and_call_original
      expect(student).to be_valid
    end
  end

  context '#full_name' do
    it 'returns the first name and the last name seperated by a space' do
      expect(student.full_name).to eq("#{student.first_name} #{student.last_name}")
    end
  end

  context '#official_name' do
    it 'returns the last name and the first name seperated by comma and space' do
      expect(student.official_name).to eq("#{student.last_name}, #{student.first_name}")
    end
  end

  context '#selection_for' do
    let(:selection) { create(:selection) }
    let(:student)   { selection.student }
    let(:poll)      { selection.poll }

    it 'returns the matching selection for the given poll' do
      expect(student.selection_for(poll)).to_not be_nil
      expect(student.selection_for(poll)).to     eq(selection)
    end

    it 'returns nil if there is no selection for the given poll' do
      other_poll = create(:poll)

      expect(student.selection_for(other_poll)).to be_nil
    end

    it 'returns nil if there is no selection at all' do
      other_student = create(:student)

      expect(other_student.selection_for(poll)).to be_nil
    end
  end

  context '#set_paused_at' do
    it 'sets the paused_at attribute if the paused_flag is "1"' do
      expect(student.paused_at).to be_nil

      student.set_paused_at

      expect(student.paused_at).to be_nil

      student.paused_flag = '1'
      student.set_paused_at

      expect(student.paused_at).to be_present
    end

    it 'sets the paused_at attribute to nil if the paused_flag is "0"' do
      student.paused_at = Time.zone.now
      expect(student.paused_at).to be_present

      student.set_paused_at

      expect(student.paused_at).to be_present

      student.paused_flag = '0'
      student.set_paused_at

      expect(student.paused_at).to be_nil
    end

    it 'leaves the paused_at attribute untouched when it is already set and paused_flag is "1"' do
      three_days_ago = Time.zone.now - 3.days
      student.paused_at = three_days_ago
      expect(student.paused_at).to be_present

      student.set_paused_at

      expect(student.paused_at).to be_present
      expect(student.paused_at.strftime('%d')).to eq(three_days_ago.strftime('%d'))

      student.paused_flag = '1'
      student.set_paused_at

      expect(student.paused_at).to be_present
      expect(student.paused_at.strftime('%d')).to eq(three_days_ago.strftime('%d'))
    end
  end
end
