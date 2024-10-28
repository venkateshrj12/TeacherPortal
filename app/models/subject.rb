class Subject < ApplicationRecord
  self.table_name = :subjects

  # associations
  belongs_to :student, foreign_key: :student_id, class_name: 'Student', optional: true

  # validations
  validates :name, presence: true, length: { maximum: 50 }
  validates :marks, presence: true,  numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
end
