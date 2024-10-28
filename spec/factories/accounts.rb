# spec/factories/accounts.rb
FactoryBot.define do
  factory :account, class: 'User::Account' do
    full_name { Faker::Name.name }
    user_name { "@#{Faker::Internet.username}" }
    email { Faker::Internet.email }
    password { 'password' } # You can also use Faker for random passwords if desired
    password_confirmation { password }
    full_phone_number { "+91#{Random.rand(6666666666...9999999999)}" }
    gender { %w[male female other].sample } # Assuming these are your enum values
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
