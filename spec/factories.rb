# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email                 { Faker::Internet.unique.safe_email }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    password              { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :educational_program do
    sequence(:name) { |n| "#{Faker::Educator.degree} #{n}" }
  end

  factory :grade do
    sequence(:name) { |n| "Class #{n + 1}" }
    educational_program
  end

  factory :student do
    email                 { Faker::Internet.unique.safe_email }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    password              { '12345678' }
    password_confirmation { '12345678' }
    grade
  end

  factory :poll do
    title       { "#{Faker::Lorem.unique.word.capitalize} #{DateTime.now.strftime('%Y')}" }
    valid_from  { 6.months.ago }
    valid_until { 6.months.from_now }
    educational_program

    trait :ended do
      valid_from  { 18.months.ago }
      valid_until { 6.months.ago }
    end
  end

  factory :course do
    title        { Faker::Educator.unique.course_name }
    minimum      { Faker::Number.within(range: 8..12) }
    maximum      { Faker::Number.within(range: 14..30) }
    description  { Faker::Lorem.paragraph(sentence_count: 10) }
    teacher_name { Faker::FunnyName.two_word_name }
    mandatory    { false }
    poll
  end

  factory :selection do
    priority { 0 }
    poll
    student
    course
  end
end
