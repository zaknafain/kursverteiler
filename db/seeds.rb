# frozen_string_literal: true

def log(output)
  Rails.logger.info(output)
end

log('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SEEDING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')

# Creates a dummy Admin for testing
log('Create a dummy Admin for testing (admin@example.com)')
admin = Admin.find_or_initialize_by(email: 'admin@example.com')
admin.assign_attributes({ first_name: 'John', last_name: 'Doe', password: 'foobar20',
                          password_confirmation: 'foobar20' })
admin.save!

# Creates some dummy Educational Program
log('Create some dummy educational program')
program = EducationalProgram.find_or_create_by!(name: 'EP 1234')

# Creates a Poll for the courses following
log('Create a poll that is running')
poll = Poll.find_or_initialize_by(educational_program: program,
                                  title: "#{Faker::Lorem.word.capitalize} #{DateTime.now.strftime('%Y')}")
poll.assign_attributes({ valid_from: 1.month.ago, valid_until: 1.month.from_now })
poll.save!

# Create 10 dummy Classes for the upcomming Students
log('------------------------ Create 10  dummy Classes ------------------------')
10.times do |index|
  name = "Class #{('A'.ord + index).chr}"
  log("Create dummy #{name}")
  Grade.find_or_create_by!(educational_program: program, name: name)
end

# Create 10 dummy Courses to fill the list
log('------------------------ Create 10 dummy Courses ------------------------')
mandatory_course = (0..9).to_a.sample
10.times do |index|
  title = Faker::Educator.course_name
  mandatory = mandatory_course == index
  log("Create dummy Course #{(index + 1).to_s.rjust(2)} #{"(#{title})".ljust(40)} #{'mandatory' if mandatory}")
  course = Course.find_or_initialize_by(title: title)
  course.poll = poll
  course.assign_attributes({ minimum: Faker::Number.within(range: 8..12),
                             maximum: Faker::Number.within(range: 14..30),
                             description: Faker::Lorem.paragraph(sentence_count: 10),
                             teacher_name: Faker::FunnyName.two_word_name,
                             mandatory: mandatory })
  course.save!
end

# Create 200 more dummy Students to fill the list
log('----------------------- Create 201 dummy Students -----------------------')

# Creates first dummy Student for testing
log("Create dummy Student   1 #{'(foo@bar.com)'.ljust(37)} in #{Grade.first.name}")
foo_bar_student = Student.find_or_initialize_by(email: 'foo@bar.com')
foo_bar_student.assign_attributes({ first_name: 'Jane', last_name: 'Doe', password: 'foobar20',
                                    password_confirmation: 'foobar20', grade: Grade.first })
foo_bar_student.save!

Grade.limit(10).each_with_index do |grade, g_index|
  20.times do |index|
    email = Faker::Internet.safe_email
    student_number = (((index + 1) + (20 * g_index)) + 1)
    log("Create dummy Student #{student_number.to_s.rjust(3)} #{"(#{email})".ljust(37)} in #{grade.name}")
    password = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
    student  = Student.find_or_initialize_by(email: email)
    student.assign_attributes({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                                password: password, password_confirmation: password, grade: grade })
    student.save!
  end
end

# Create Selections for all Students to have a real Poll running
log('-------------------- Create Selections  for Students --------------------')
Student.all.each do |student|
  selection_amount = (0..3).to_a.sample
  selected_courses = Course.where(mandatory: false).order(Arel.sql('RAND()')).first(selection_amount)
  course_names = selected_courses.map(&:title).join(', ')
  log("Student #{student.id.to_s.rjust(3)} selected following courses: #{course_names}") unless selection_amount.zero?
  selection_amount.times do |priority|
    selection = student.selections.build(poll: poll, priority: priority, course: selected_courses.pop)
    selection.save!
  end
  next unless selection_amount.zero?

  mandatory_course = Course.where(mandatory: true).first
  student.selections.create!(poll: poll, priority: 0, course: mandatory_course)
  log("Student #{student.id.to_s.rjust(3)} selected mandatory  course: #{mandatory_course.title}")
end
