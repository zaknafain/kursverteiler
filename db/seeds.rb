# frozen_string_literal: true

def log(output)
  Rails.logger.info(output)
end

if Rails.env.development?
  log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SEEDING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')

  # Creates a dummy Admin for testing
  log('Create a dummy Admin for testing (admin@example.com)')
  admin = Admin.find_or_initialize_by(email: 'admin@example.com')
  admin.assign_attributes({ first_name: 'John', last_name: 'Doe', password: 'foobar20',
                            password_confirmation: 'foobar20' })
  admin.save!

  # Create 2 dummy Polls for the courses following
  log('------------------------- Create 2  dummy Polls -------------------------')
  [Time.zone.today.year - 1, Time.zone.today.year].each do |year|
    title = "Kurswahl #{year}"
    log("Create #{title}")
    poll = Poll.find_or_initialize_by(title: title)
    poll.assign_attributes({ valid_from: Date.new(year), valid_until: Date.new(year, 12, 31) })
    poll.save!
  end

  # Create 10 dummy Classes for the upcomming Students
  log('------------------------ Create 10 dummy Classes ------------------------')
  10.times do |index|
    name = "Klasse #{('A'.ord + index).chr}"
    log("Create dummy #{name}")
    grade = Grade.find_or_create_by!(name: name)
    grade.polls << Poll.all
  end

  # Create 20 dummy Courses to fill the list
  log('------------------------ Create 20 dummy Courses ------------------------')
  Poll.all.each_with_index do |poll, poll_index|
    guaranteed_course = (0..9).to_a.sample
    10.times do |index|
      title = Faker::Educator.course_name
      guaranteed = guaranteed_course == index
      course_number = ((index + 1) + (10 * poll_index))
      log("Create dummy Course #{course_number.to_s.rjust(2)} #{"(#{title})".ljust(39)} #{'guaranteed' if guaranteed}")
      course = Course.find_or_initialize_by(title: title)
      course.poll = poll
      course.assign_attributes({ minimum: Faker::Number.within(range: 8..12),
                                 maximum: Faker::Number.within(range: 14..30),
                                 description: Faker::Lorem.paragraph(sentence_count: 10),
                                 teacher_name: Faker::FunnyName.two_word_name,
                                 focus_areas: Faker::Lorem.sentence(word_count: 0, random_words_to_add: 7),
                                 variants: Faker::Lorem.sentence(word_count: 4, random_words_to_add: 7),
                                 guaranteed: guaranteed })
      course.save!
    end
  end

  # Create 201 more dummy Students to fill the list
  log('----------------------- Create 201 dummy Students -----------------------')

  # Creates first dummy Student for testing
  log("Create dummy Student   1 #{'(foo@bar.com)'.ljust(37)} in #{Grade.first.name}")
  foo_bar_student = Student.find_or_initialize_by(email: 'foo@bar.com')
  foo_bar_student.assign_attributes({ first_name: 'Jane', last_name: 'Doe', password: 'foobar20',
                                      password_confirmation: 'foobar20', grade: Grade.first })
  foo_bar_student.save!

  Grade.limit(10).each_with_index do |grade, grade_index|
    20.times do |index|
      email = Faker::Internet.safe_email
      student_number = (((index + 1) + (20 * grade_index)) + 1)
      log("Create dummy Student #{student_number.to_s.rjust(3)} #{"(#{email})".ljust(36)} in #{grade.name}")
      password = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
      student  = Student.find_or_initialize_by(email: email)
      student.assign_attributes({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                                  password: password, password_confirmation: password, grade: grade })
      student.save!
    end
  end

  # Create Selections for all Students and Polls
  log('-------------------- Create Selections  for Students --------------------')
  Poll.all.each do |poll|
    Student.all.each do |student|
      selection_amount = (0..3).to_a.sample
      selected_courses = poll.courses.where(guaranteed: false).order(Arel.sql('RANDOM()')).first(selection_amount)
      course_names = selected_courses.map(&:title).join(', ')
      unless selection_amount.zero?
        log("Student #{student.id.to_s.rjust(3)} selected following courses: #{course_names}")
      end
      selection_amount.times do |priority|
        selection = student.selections.build(priority: priority, course: selected_courses.pop)
        selection.save!
      end
      next unless selection_amount.zero?

      guaranteed_course = poll.courses.find_by(guaranteed: true)
      student.selections.create!(priority: 0, course: guaranteed_course)
      log("Student #{student.id.to_s.rjust(3)} selected guaranteed course: #{guaranteed_course.title}")
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
