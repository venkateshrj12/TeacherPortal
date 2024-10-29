
unless User::Account.find_by(user_name: "principal")
    User::Account.create(
    full_name: "School Principal",
    email: "principal@school.com",
    password: "password",
    role: "principal",
    user_name:  "@principal",
    gender:  "male",
    date_of_birth:  "1990-01-01",
    full_phone_number: "+919876543210"
  )
end

teachers = [
  { full_name: "John Doe", email: "teacher1@school.com", user_name: "@teacher1", gender: "male", date_of_birth: "1985-05-15", full_phone_number: "+919876543211" },
  { full_name: "Jane Smith", email: "teacher2@school.com", user_name: "@teacher2", gender: "female", date_of_birth: "1988-07-22", full_phone_number: "+919876543212" },
  { full_name: "Alice Johnson", email: "teacher3@school.com", user_name: "@teacher3", gender: "female", date_of_birth: "1983-03-30", full_phone_number: "+919876543213" },
  { full_name: "Michael Brown", email: "teacher4@school.com", user_name: "@teacher4", gender: "male", date_of_birth: "1992-11-11", full_phone_number: "+919876543214" },
  { full_name: "Emily Davis", email: "teacher5@school.com", user_name: "@teacher5", gender: "female", date_of_birth: "1990-09-09", full_phone_number: "+919876543215" },
]

teachers.each do |teacher|
  unless User::Account.find_by(user_name: teacher[:user_name])
    User::Account.create(
      full_name: teacher[:full_name],
      email: teacher[:email],
      password: "password",
      role: "teacher",
      user_name: teacher[:user_name],
      gender: teacher[:gender],
      date_of_birth: teacher[:date_of_birth],
      full_phone_number: teacher[:full_phone_number]
    )
  end
end


