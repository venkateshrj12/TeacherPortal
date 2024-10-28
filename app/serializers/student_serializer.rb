class StudentSerializer < ApplicationSerializer
  attributes(:id, :full_name)

  attribute :subjects do |student|
    SubjectSerializer.new(student&.subjects).serializable_hash[:data]&.map{ |subject| subject[:attributes] }
  end
end