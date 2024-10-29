class Student < ApplicationRecord
  self.table_name = :students

  # associations
  belongs_to :user_account, class_name: "User::Account", foreign_key: :user_account_id

  # validations
  validates :full_name, :subject, presence: true, length: { maximum: 50 }
  validates :marks,  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
end
