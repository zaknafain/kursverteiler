# frozen_string_literal: true

FactoryBot.define do
  factory :admin do
    email                 { Faker::Internet.unique.safe_email }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    password              { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :grade do
    sequence(:name) { |n| "Class #{n + 1}" }
  end

  factory :student do
    email                 { Faker::Internet.unique.safe_email }
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name }
    password              { '12345678' }
    password_confirmation { '12345678' }
    grade

    trait :paused do
      grade     { nil }
      paused_at { Time.zone.now }
    end
  end

  factory :poll do
    sequence(:title) { |n| "#{Faker::Lorem.word.capitalize} #{DateTime.now.strftime('%Y')}-#{n}" }
    valid_from       { 6.months.ago }
    valid_until      { 6.months.from_now }
    description      { Faker::Lorem.paragraph(sentence_count: 2) }

    trait :ended do
      valid_from  { 18.months.ago - 1.day }
      valid_until { 6.months.ago - 1.day }
    end

    trait :future do
      valid_from  { 6.months.from_now + 1.day }
      valid_until { 18.months.from_now + 1.day }
    end
  end

  factory :grades_poll do
    grade
    poll
  end

  factory :course, aliases: %i[top_course mid_course low_course] do
    title        { Faker::Educator.unique.course_name }
    minimum      { Faker::Number.within(range: 8..12) }
    maximum      { Faker::Number.within(range: 14..30) }
    description  { Faker::Lorem.paragraph(sentence_count: 10) }
    teacher_name { Faker::FunnyName.two_word_name }
    guaranteed   { false }
    poll
  end

  factory :courses_student do
    course
    student
  end

  factory :selection do
    poll
    student
    top_course
    mid_course
    low_course

    trait :clean do
      top_course { nil }
      mid_course { nil }
      low_course { nil }
    end
  end
end
