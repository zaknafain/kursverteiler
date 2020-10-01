# frozen_string_literal: true

puts '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> SEEDING <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<'

# Creates a dummy Admin for testing
puts 'Create a dummy Admin for testing (admin@example.com)'
admin = Admin.find_or_initialize_by(email: 'admin@example.com')
admin.assign_attributes({ first_name: 'John', last_name: 'Doe', password: 'foobar20',
                          password_confirmation: 'foobar20' })
admin.save!

# Creates a dummy Student for testing
puts 'Create a dummy Student for testing (foo@bar.com)'
student = Student.find_or_initialize_by(email: 'foo@bar.com')
student.assign_attributes({ first_name: 'Jane', last_name: 'Doe', password: 'foobar20',
                            password_confirmation: 'foobar20' })
student.save!

# Creates a poll for the courses following
puts 'Create a poll that is running'
poll = Poll.find_or_initialize_by(title: "#{Faker::Lorem.word.capitalize} #{DateTime.now.strftime('%Y')}")
poll.assign_attributes({ valid_from: 1.month.ago, valid_until: 1.month.from_now })
poll.save!

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
puts '----------------------- Create 200 dummy Students -----------------------'
200.times do |index|
  email = Faker::Internet.safe_email
  puts "Create dummy Student #{(index + 1).to_s.rjust(3)} (#{email})"
  password = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
  student  = Student.find_or_initialize_by(email: email)
  student.assign_attributes({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                              password: password, password_confirmation: password })
  student.save!
end

# Create Selections for all Students to have a real Poll running
puts '-------------------- Create Selections  for Students --------------------'
Student.all.each do |student|
  selection_amount = (0..3).to_a.sample
  selected_courses = Course.order(Arel.sql('RAND()')).first(selection_amount)
  puts "Student #{(student.id + 1).to_s.rjust(3)} selected following courses: #{selected_courses.map(&:title).join(', ')}"
  selection_amount.times do |priority|
    selection = student.selections.build(poll: poll, priority: priority, course: selected_courses.pop)
    selection.save!
  end
end
