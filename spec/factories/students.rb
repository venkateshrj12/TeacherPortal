FactoryBot.define do
  factory :student, class: Student do
    full_name { Faker::Name.name }
    user_account { create(:account) }
  end

  factory :invalid_student, class: Student do
    full_name { Random.alphanumeric(100) }
    user_account { create(:account) }
  end
end
