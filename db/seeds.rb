# frozen_string_literal: true

puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SEEDING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'

# Creates a dummy Admin for testing
puts 'Create a dummy Admin for testing (admin@example.com)'
admin = Admin.find_or_initialize_by(email: 'admin@example.com')
admin.assign_attributes({ first_name: 'John', last_name: 'Doe', password: 'foobar20',
                          password_confirmation: 'foobar20' })
admin.save!

# Creates some dummy Educational Program
puts 'Create some dummy educational program'
program = EducationalProgram.find_or_create_by!(name: 'EP 1234')

# Creates a Poll for the courses following
puts 'Create a poll that is running'
poll = Poll.find_or_initialize_by(educational_program: program, title: "#{Faker::Lorem.word.capitalize} #{DateTime.now.strftime('%Y')}")
poll.assign_attributes({ valid_from: 1.month.ago, valid_until: 1.month.from_now })
poll.save!

# Create 10 dummy Classes for the upcomming Students
puts '------------------------ Create 10  dummy Classes ------------------------'
10.times do |index|
  name = "Class #{('A'.ord + index).chr}"
  puts "Create dummy #{name}"
  Grade.find_or_create_by!(educational_program: program, name: name)
end

# Create 10 dummy Courses to fill the list
puts '------------------------ Create 10 dummy Courses ------------------------'
10.times do |index|
  title = Faker::Educator.course_name
  puts "Create dummy Course #{(index + 1).to_s.rjust(2)} (#{title})"
  course = Course.find_or_initialize_by(title: title)
  course.poll = poll
  course.assign_attributes({ minimum: Faker::Number.within(range: 8..12),
                             maximum: Faker::Number.within(range: 14..30),
                             description: Faker::Lorem.paragraph(sentence_count: 10),
                             teacher_name: Faker::FunnyName.two_word_name })
  course.save!
end

# Create 200 more dummy Students to fill the list
puts '----------------------- Create 201 dummy Students -----------------------'

# Creates first dummy Student for testing
puts "Create dummy Student   1 #{'(foo@bar.com)'.ljust(40)} in #{Grade.first.name}"
student = Student.find_or_initialize_by(email: 'foo@bar.com')
student.assign_attributes({ first_name: 'Jane', last_name: 'Doe', password: 'foobar20',
                            password_confirmation: 'foobar20', grade: Grade.first })
student.save!

Grade.limit(10).each_with_index do |grade, g_index|
  20.times do |index|
    email = Faker::Internet.safe_email
    puts "Create dummy Student #{(((index + 1) + (20 * g_index)) + 1).to_s.rjust(3)} #{('(' + email + ')').ljust(40)} in #{grade.name}"
    password = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
    student  = Student.find_or_initialize_by(email: email)
    student.assign_attributes({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                                password: password, password_confirmation: password, grade: grade })
    student.save!
  end
end

# Create Selections for all Students to have a real Poll running
puts '-------------------- Create Selections  for Students --------------------'
Student.all.each do |student|
  selection_amount = (0..3).to_a.sample
  selected_courses = Course.order(Arel.sql('RAND()')).first(selection_amount)
  puts "Student #{(student.id).to_s.rjust(3)} selected following courses: #{selected_courses.map(&:title).join(', ')}"
  selection_amount.times do |priority|
    selection = student.selections.build(poll: poll, priority: priority, course: selected_courses.pop)
    selection.save!
  end
end
