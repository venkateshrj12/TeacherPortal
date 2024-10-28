FactoryBot.define do
  factory :subject, class: Subject do
    name { "MyString" }
    marks { 100 }
    student { create(:student) }
  end

  factory :invalid_subject, class: Subject do
    name { Random.alphanumeric(100) }
    marks { 101 }
    student { create(:student) }
  end
end
