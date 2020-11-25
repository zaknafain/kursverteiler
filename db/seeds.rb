# frozen_string_literal: true

def log(output)
  Rails.logger.info(output)
end

if Rails.env.development?
  log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SEEDING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
  if Admin.count.positive?
    log('!!!!!!!!!!!!!!!!!!!!!!!!!!!!! DB NOT  EMPTY !!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    return
  end

  # Creates a dummy Admin for testing
  log('Create a dummy Admin for testing (admin@example.com)')
  Admin.create!({ email: 'admin@example.com', first_name: 'John', last_name: 'Doe', password: 'foobar20',
                  password_confirmation: 'foobar20' })

  # Create 2 dummy Polls for the courses following
  log('------------------------- Create 2  dummy Polls -------------------------')
  polls = [Time.zone.today.year - 1, Time.zone.today.year].map do |year|
    title = "Kurswahl #{year}"
    log("Create #{title}")
    Poll.create!({ title: title, valid_from: Date.new(year), valid_until: Date.new(year, 12, 31),
                   description: Faker::Lorem.paragraph(sentence_count: 10) })
  end

  # Create 10 dummy Classes for the upcomming Students
  log('------------------------ Create 10 dummy Classes ------------------------')
  grades = (0..9).to_a.map do |index|
    name = "Klasse #{('A'.ord + index).chr}"
    log("Create dummy #{name}")

    Grade.create!({ name: name, polls: polls })
  end

  # Create 20 dummy Courses to fill the list
  log('------------------------ Create 20 dummy Courses ------------------------')
  polls.each_with_index do |poll, poll_index|
    guaranteed_course = (0..9).to_a.sample
    10.times do |index|
      title = Faker::Educator.course_name
      guaranteed = guaranteed_course == index
      course_number = ((index + 1) + (10 * poll_index))
      log("Create dummy Course #{course_number.to_s.rjust(2)} #{"(#{title})".ljust(39)} #{'guaranteed' if guaranteed}")
      Course.create!({ title: title, poll: poll, minimum: guaranteed ? nil : Faker::Number.within(range: 8..12),
                       guaranteed: guaranteed, maximum: guaranteed ? nil : Faker::Number.within(range: 14..30),
                       description: Faker::Lorem.paragraph(sentence_count: 10),
                       teacher_name: Faker::FunnyName.two_word_name,
                       focus_areas: Faker::Lorem.sentence(word_count: 0, random_words_to_add: 7),
                       variants: Faker::Lorem.sentence(word_count: 4, random_words_to_add: 7) })
    end
  end

  # Create 201 more dummy Students to fill the list
  log('----------------------- Create 200 dummy Students -----------------------')

  # Creates first dummy Student for testing
  sample_grade = grades.sample
  log("Create dummy Student   1 #{'(foo@bar.com)'.ljust(37)} in #{sample_grade.name}")
  Student.create!({ email: 'foo@bar.com', first_name: 'Jane', last_name: 'Doe', password: 'foobar20',
                    password_confirmation: 'foobar20', grade: sample_grade })

  grade_size = 20
  grades.each_with_index do |grade, grade_index|
    missing_students = grade_size - grade.students.length
    missing_students.times do |index|
      email = Faker::Internet.unique.safe_email
      student_number = (((index + 1) + (grade_size * grade_index)) + 1)
      log("Create dummy Student #{student_number.to_s.rjust(3)} #{"(#{email})".ljust(36)} in #{grade.name}")
      password = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
      Student.create!({ email: email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                        password: password, password_confirmation: password, grade: grade })
    end
  end

  # Create Selections for all Students and Polls
  log('-------------------- Create Selections  for Students --------------------')
  polls.each do |poll|
    Student.all.each do |student|
      selection_amount = (0..3).to_a.sample
      selected_courses = poll.courses.where(guaranteed: false).order(Arel.sql('RANDOM()')).first(selection_amount)
      course_names = selected_courses.map(&:title).join(', ')
      unless selection_amount.zero?
        log("Student #{student.id.to_s.rjust(3)} selected following courses: #{course_names}")
      end
      selection = student.selections.build(poll: poll)
      selection.top_course = selected_courses.pop
      selection.mid_course = selected_courses.pop
      selection.low_course = selected_courses.pop
      selection.save!
      next unless selection_amount.zero?

      guaranteed_course = poll.courses.find_by(guaranteed: true)
      selection.update!(top_course: guaranteed_course)
      log("Student #{student.id.to_s.rjust(3)} selected guaranteed course: #{guaranteed_course.title}")
    end
  end

  # Create distribution for all Polls from the past
  log('------------------ Create Distribution  for past Polls ------------------')
  polls.select{ |p| p.valid_until < Time.zone.today }.each do |poll|
    log("Starting Distribution for poll #{poll.title}")
    not_distributed_students = []

    selections = poll.selections
    poll.students.each do |student|
      top_course = selections.detect { |s| s.student_id == student.id }&.top_course
      mid_course = selections.detect { |s| s.student_id == student.id }&.mid_course
      low_course = selections.detect { |s| s.student_id == student.id }&.low_course
      if top_course&.guaranteed
        log("Distribute #{student.full_name} to guaranteed #{top_course.title}")
        student.courses_students.create!(course: top_course)
      elsif top_course && top_course.students.length < top_course.maximum
        log("Distribute #{student.full_name} to 1st choice #{top_course.title}")
        student.courses_students.create!(course: top_course)
      elsif mid_course && mid_course.students.length < mid_course.maximum
        log("Distribute #{student.full_name} to 2nd choice #{mid_course.title}")
        student.courses_students.create!(course: mid_course)
      elsif low_course && low_course.students.length < low_course.maximum
        log("Distribute #{student.full_name} to 3rd choice #{low_course.title}")
        student.courses_students.create!(course: low_course)
      else
        not_distributed_students << student
      end
    end

    not_distributed_students.each do |student|
      poll.courses.each do |course|
        if course.guaranteed == false && course.students.length < course.maximum
          log("Distribute #{student.full_name} to #{course.title}")
          student.courses_students.create!(course: course)
        end
      end
    end
  end
elsif Rails.env.production?
  # Create new Administrator
  log('-------------------- Create new Admin  to the Rescue --------------------')
  Admin.create!(email: Rails.application.credentials.admin[:email],
                first_name: Rails.application.credentials.admin[:first_name],
                last_name: Rails.application.credentials.admin[:last_name],
                password: Rails.application.credentials.admin[:password],
                password_confirmation: Rails.application.credentials.admin[:password])
end
