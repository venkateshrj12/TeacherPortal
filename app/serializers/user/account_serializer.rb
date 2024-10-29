# app\serializers\user\account_serializer.rb
module User
  class AccountSerializer < ApplicationSerializer
    attributes :id, :full_name, :user_name, :full_phone_number, :country_code, :phone_number, :email, :activated, :last_visit_at, :gender, :date_of_birth, :role

    attribute :students do |account|
      account.students&.count || 0
    end
  end
end
