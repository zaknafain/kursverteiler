# frozen_string_literal: true

# Creates a dummy Student for testing
student = Student.find_or_initialize_by(email: 'foo@bar.com')
student.password = student.password_confirmation = 'foobar20'
student.save!

# Creates a dummy Admin for testing
admin = Admin.find_or_initialize_by(email: 'admin@example.com')
admin.password = admin.password_confirmation = 'foobar20'
admin.save!
