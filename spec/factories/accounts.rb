# spec/factories/accounts.rb
FactoryBot.define do
  factory :account, class: User::Account do
    full_name { Faker::Name.name }
    user_name { "@#{Faker::Internet.username}" }
    email { Faker::Internet.email }
    password { 'password' } 
    password_confirmation { password }
    full_phone_number { "+91#{Random.rand(6666666666...9999999999)}" }
    gender { %w[male female other].sample }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end

  factory :invalid_account, class: User::Account do
    full_name { Faker::Name.name }
    user_name { "@#{Faker::Internet.username}" }
    email { "invalid email" }
    password { 'password' } 
    password_confirmation { password }
    full_phone_number { "invalid full phone number" }
    gender { "M" } 
    date_of_birth { Time.now }
  end
end
