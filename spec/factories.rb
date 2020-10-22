# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email                 { Faker::Internet.safe_email }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    password              { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :educational_program do
    name { Faker::Educator.degree }
  end

  factory :student do
    email                 { Faker::Internet.safe_email }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    password              { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :poll do
    title       { "#{Faker::Lorem.word.capitalize} #{DateTime.now.strftime('%Y')}" }
    valid_from  { 6.months.ago }
    valid_until { 6.months.from_now }
    educational_program
  end

  factory :course do
    title        { Faker::Educator.course_name }
    minimum      { Faker::Number.within(range: 8..12) }
    maximum      { Faker::Number.within(range: 14..30) }
    description  { Faker::Lorem.paragraph(sentence_count: 10) }
    teacher_name { Faker::FunnyName.two_word_name }
    poll
  end

  factory :selection do
    priority { 0 }
    poll
    student
    course
  end
end
