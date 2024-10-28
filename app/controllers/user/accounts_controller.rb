module User
  class AccountsController < User::ApplicationController
    before_action :validate_jwt, except: :create

    # GET /user/accounts
    def index
      @user_accounts = User::Account.page(@page).per(@per_page)
      pagination_details = pagination_details(@user_accounts)
      
      render json: {
        pagination_details: pagination_details,
        data: AccountSerializer.new(@user_accounts).serializable_hash[:data]
      }
    end

    # GET /user/accounts/1
    def show
      @user_account = User::Account.find_by(id: params[:id])
      if @user_account
        render json: AccountSerializer.new(@user_account).serializable_hash
      else
        render json:  { errors: ['Account not found'] }, status: :not_found
      end
    end

    # POST /user/accounts
    def create #signup
      @user_account = User::Account.new(user_account_params)
      if @user_account.save
        expiration = Time.now + 30.days
        auth_token = ::JsonWebToken.encode({id: @user_account.id}, expiration)
        render json: AccountSerializer.new(@user_account, meta: {auth_token: auth_token}), status: :created
      else
        render json: {errors: @user_account.errors.full_messages}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /user/accounts/1
    def update
      if @current_user.update(user_account_params)
        render json: AccountSerializer.new(@current_user).serializable_hash
      else
        render json: {errors: @current_user.errors.full_messages}, status: :unprocessable_entity
      end
    end

    # DELETE /user/accounts/1
    def destroy
      @current_user&.destroy!
      render json: {messages: ["Account deleted successfully"]}, status: :ok
    end

    private

    # Only allow a list of trusted parameters through.
    def user_account_params
      params.permit(:full_name, :full_phone_number, :email, :password, :password_confirmation, :user_name, :gender, :date_of_birth)
    end
  end
end
