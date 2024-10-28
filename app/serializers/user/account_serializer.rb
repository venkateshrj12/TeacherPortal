# app\serializers\user\account_serializer.rb
module User
  class AccountSerializer < ApplicationSerializer
    attributes :id, :full_name, :user_name, :full_phone_number, :country_code, :phone_number, :email, :activated, :last_visit_at, :gender, :date_of_birth, :role

  end
end
