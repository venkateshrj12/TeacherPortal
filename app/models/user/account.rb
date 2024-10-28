module User
  class Account < ApplicationRecord
    self.table_name = :user_accounts
    has_secure_password

    enum gender: { male: 'Male', female: 'Female', other: 'Other' }.freeze
    enum role: { teacher: 0, principal: 1 }.freeze

    # validations
    validates :full_name, :gender, :date_of_birth, :email, presence: true
    validates :user_name, :email, uniqueness: true
    validates :full_phone_number, uniqueness: true, allow_blank: true
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

    # scopes
    scope :active, -> { where(activated: true) }

    # callbacks
    before_validation { self.email = self.email&.downcase }
    before_validation :assign_user_name, :validate_phone_number, :validate_email, :validate_date_of_birth

    private

    def validate_phone_number
      return if full_phone_number.blank?
    
      unless Phonelib.valid?(full_phone_number)
        errors.add(:full_phone_number, "Invalid or Unrecognized Phone Number")
        return
      end
    
      phone = Phonelib.parse(full_phone_number)
      self.full_phone_number = phone.sanitized
      self.country_code = phone.country_code
      self.phone_number = phone.raw_national
    end

    def validate_email
      email_regexp = /[^@]+@\S+[.]\S+/

      if self.email.nil?
        return self.errors
      elsif !email.match?(email_regexp)
        return errors.add(:email, "Invalid Email")
      end
    end

    def validate_date_of_birth
      unless self.date_of_birth <  Date.today - 18.years
        errors.add(:base, "Age must be at least 18 years old to create an account of teacher")
      end
    end

    def assign_user_name
      unless self.user_name
        full_name = self.full_name 
        self.user_name = "@#{generate_unique_user_name(full_name)}"
      end
    end

    def generate_unique_user_name(full_name = nil)
      full_name = full_name || self.full_name
      new_user_name = "#{full_name&.downcase&.gsub(/\s+/, '_')}#{rand(10000..99999).to_s}"
      while Account.exists?(user_name: new_user_name)
        new_user_name = full_name.downcase.gsub(/\s+/, '_') + rand(10000..99999).to_s
      end
      new_user_name
    end

  end
end
