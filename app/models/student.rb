class Student < ApplicationRecord
  self.table_name = :students

  # associations
  belongs_to :user_account, class_name: "User::Account", foreign_key: :user_account_id
  has_many :subjects, class_name: "Subject", foreign_key: :student_id, dependent: :destroy
  accepts_nested_attributes_for :subjects, allow_destroy: true

  # validations
  validates :full_name, presence: true, uniqueness: true, length: { maximum: 50 }
end
