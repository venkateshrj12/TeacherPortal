module User
  class LoginController < User::ApplicationController
    before_action :validate_jwt, only: :me
    
    def create # login
      login_creds = params[:login_creds]
      password = params[:password]

      user = find_user(login_creds)

      if user
        if user.authenticate(password)
          expiration = Time.now + 30.days
          auth_token = ::JsonWebToken.encode({id: user.id}, expiration)

          render json: LoggedUserSerializer.new(user, meta: {auth_token: auth_token}), status: :ok

        else
          return render json: {errors: ['Incorrect password']}, status: :unprocessable_entity
        end
      else
        render json: {errors: ['Account not found']}, status: :unprocessable_entity
      end
    end

    def me
      if @current_user
        render json: LoggedUserSerializer.new(@current_user).serializable_hash
      else
        render json: {errors: ['You are not logged in']}, status: :unauthorized
      end
    end

    private

    def find_user(login_creds)
      email_regexp = /[^@]+@\S+[.]\S+/
      user_name_regexp = /\A@\w+\z/

      email = login_creds&.match?(email_regexp)
      user_name = login_creds&.match?(user_name_regexp)
      
      phone = Phonelib.parse(login_creds).sanitized

      if email
        User::Account.find_by(email: login_creds&.downcase)
      elsif user_name
        User::Account.find_by(user_name: login_creds)
      else
        User::Account.find_by(full_phone_number: phone) || 
        User::Account.find_by(phone_number: phone)
      end
    end

  end
end
