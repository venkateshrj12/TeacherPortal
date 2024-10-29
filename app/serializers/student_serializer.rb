class StudentSerializer < ApplicationSerializer
  attributes(:id, :full_name, :subject, :marks)
end