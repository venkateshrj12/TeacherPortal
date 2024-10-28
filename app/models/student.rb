class Student < ApplicationRecord
  self.table_name = :students

  belongs_to :user_account, class_name: "User::Account", foreign_key: :user_account_id

  validates :full_name, presence: true, uniqueness: true, length: { maximum: 50 }
end
