# frozen_string_literal: true

def log(output)
  Rails.logger.info(output)
end

if Rails.application.credentials.dig(:db, :allow_seeding) || ENV.fetch('DB_ALLOW_SEEDING', false)
  log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SEEDING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
  if Admin.count.positive?
    log('!!!!!!!!!!!!!!!!!!!!!!!!!!!!! CLEARING DB !!!!!!!!!!!!!!!!!!!!!!!!!!!!!')
    Admin.all.destroy_all
    Poll.all.destroy_all
    Grade.all.destroy_all
  end

  # Creates a dummy Admin for testing
  log('Create a dummy Admin for testing (admin@example.com)')
  Admin.create!({ email: 'admin@example.com', first_name: 'John', last_name: 'Doe', password: 'foobar20',
                  password_confirmation: 'foobar20' })

  # Create 2 dummy Polls for the courses following
  log('------------------------- Create 2  dummy Polls -------------------------')
  polls = [Time.zone.today.year - 1, Time.zone.today.year].map do |year|
    title = "Kurswahl #{year}"
    end_of_year = Date.new(year, 12, 31)
    completed = if end_of_year < Time.zone.today
                  Faker::Time.between_dates(from: end_of_year + 1.day, to: end_of_year + 3.days, period: :day)
                end
    log("Create #{title}")
    Poll.create!({ title: title, valid_from: Date.new(year), valid_until: end_of_year,
                   description: Faker::Lorem.paragraph(sentence_count: 10),
                   completed: completed })
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
      course = Course.create!({ title: title, poll: poll, guaranteed: guaranteed,
                                minimum: guaranteed ? nil : Faker::Number.within(range: 8..12),
                                maximum: guaranteed ? nil : Faker::Number.within(range: 16..26),
                                description: Faker::Lorem.paragraph(sentence_count: 10),
                                teacher_name: Faker::FunnyName.two_word_name,
                                number: Faker::Number.within(range: 1000..2000),
                                focus_areas: Faker::Lorem.words(number: (0..6).to_a.sample).join(' '),
                                variants: Faker::Lorem.words(number: (0..6).to_a.sample).join(' ') })
      course.update!(
        parent_course: Course.parent_candidates_for(course).detect { |c| c.title.start_with?(course.title[0..4]) }
      )
    end
  end

  # Create 205 more dummy Students to fill the list
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
  from = polls.min_by(&:valid_from).valid_from + 1.day
  ((Student.count)..(Student.count + 5)).to_a.each do |index|
    email = Faker::Internet.unique.safe_email
    log("Create dummy Student #{index.to_s.rjust(3)} #{"(#{email})".ljust(36)} paused")
    password = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
    to       = Time.zone.today - 1.day
    paused   = Faker::Time.between_dates(from: from, to: to, period: :day)
    Student.create!({ email: email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                      password: password, password_confirmation: password, paused_at: paused })
    from = paused
  end

  # Create distribution for all Polls from the past
  polls.each do |poll|
    log("Starting Selections for poll #{poll.title}")
    Student.all.each do |student|
      next if student.paused_at && student.paused_at < poll.valid_until

      selection_amount = [0, 3, 3, 3, 3, 3, 3, 3].sample
      selected_courses = poll.courses.where(guaranteed: false).to_a.shuffle
      selected_courses = selected_courses.select { |c| student.courses.map(&:id).exclude?(c.parent_course_id) }
      selection = student.selections.build(poll: poll)
      if selection_amount.positive? && selected_courses.length >= 3
        course_names = selected_courses.first(3).map(&:title).join(', ')
        log("Student #{student.id.to_s.rjust(3)} selected following courses: #{course_names}")
        selection.top_course = selected_courses.pop
        selection.mid_course = selected_courses.pop
        selection.low_course = selected_courses.pop
        selection.save!
      else
        guaranteed_course = poll.courses.find_by(guaranteed: true)
        next if guaranteed_course.top_selections.length >= 10

        selection.update!(top_course: guaranteed_course)
        log("Student #{student.id.to_s.rjust(3)} selected guaranteed course: #{guaranteed_course.title}")
      end
    end

    next if poll.completed.blank?

    log("Starting Distribution for poll #{poll.title}")
    not_distributed_students = []

    Student.all.each do |student|
      selection  = poll.selections.detect { |s| s.student_id == student.id }
      top_course = selection&.top_course
      mid_course = selection&.mid_course
      low_course = selection&.low_course
      if top_course&.guaranteed
        log("Distribute #{student.full_name} to guaranteed #{top_course.title}")
        student.courses << top_course
      elsif top_course && top_course.students.length < top_course.maximum
        log("Distribute #{student.full_name} to 1st choice #{top_course.title}")
        student.courses << top_course
      elsif mid_course && mid_course.students.length < mid_course.maximum
        log("Distribute #{student.full_name} to 2nd choice #{mid_course.title}")
        student.courses << mid_course
      elsif low_course && low_course.students.length < low_course.maximum
        log("Distribute #{student.full_name} to 3rd choice #{low_course.title}")
        student.courses << low_course
      else
        not_distributed_students << student
      end
    end

    not_distributed_students.each do |student|
      courses = poll.courses.where(guaranteed: false).to_a.shuffle
      course  = courses.detect { |c| c.students.length < c.maximum } || courses.first
      student.courses << course
      log("Distribute #{student.full_name} to #{course.title}")
    end
  end

  log('----------------------------- Seeding  done -----------------------------')
elsif Rails.application.credentials.dig(:admin, :email)
  # Create new Administrator
  log('-------------------- Create new Admin  to the Rescue --------------------')
  Admin.create!(email: Rails.application.credentials.admin[:email],
                first_name: Rails.application.credentials.admin[:first_name],
                last_name: Rails.application.credentials.admin[:last_name],
                password: Rails.application.credentials.admin[:password],
                password_confirmation: Rails.application.credentials.admin[:password])
end
