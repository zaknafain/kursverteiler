# frozen_string_literal: true

# Creates a dummy Student for testing
student = Student.find_or_initialize_by(email: 'foo@bar.com')
student.assign_attributes({ first_name: 'Jane', last_name: 'Doe', password: 'foobar20',
                            password_confirmation: 'foobar20' })
student.save!
# Create 200 more dummy Students to fill the list
200.times do
  email    = Faker::Internet.safe_email
  password = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
  student  = Student.find_or_initialize_by(email: email)
  student.assign_attributes({ first_name: Faker::Name.first_name, last_name: Faker::Name.last_name,
                              password: password, password_confirmation: password })
  student.save!
end

# Creates a dummy Admin for testing
admin = Admin.find_or_initialize_by(email: 'admin@example.com')
admin.assign_attributes({ first_name: 'John', last_name: 'Doe', password: 'foobar20',
                          password_confirmation: 'foobar20' })
admin.save!
