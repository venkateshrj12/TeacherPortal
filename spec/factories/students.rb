FactoryBot.define do
  factory :student, class: Student do
    full_name { Faker::Name.name }
    subject { "Physics" }
    marks { 50 }
    user_account { create(:account) }
  end

  factory :invalid_student, class: Student do
    full_name { Random.alphanumeric(100) }
    subject { Random.alphanumeric(100) }
    marks { 500 }
    user_account { create(:account) }
  end
end
