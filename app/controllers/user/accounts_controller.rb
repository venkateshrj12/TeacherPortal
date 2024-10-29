module User
  class AccountsController < User::ApplicationController
    before_action :validate_jwt
    before_action :validate_principal, except: [:update]
    before_action :set_user_account, only: [:show, :destroy]

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
      end
    end

    # POST /user/accounts
    def create
      @user_account = User::Account.new(user_account_params)
      if @user_account.save
        render json: AccountSerializer.new(@user_account), status: :created
      else
        render json: {errors: @user_account.errors.full_messages}, status: :unprocessable_entity
      end
    end

    # PATCH /user/accounts
    def update
      if @current_user.update(user_account_update_params)
        render json: AccountSerializer.new(@current_user).serializable_hash
      else
        render json: {errors: @current_user.errors.full_messages}, status: :unprocessable_entity
      end
    end

    # DELETE /user/accounts/1
    def destroy
      @user_account&.destroy!
      render json: {messages: ["Account deleted successfully"]}, status: :ok
    end

    private

    # Only allow a list of trusted parameters through.
    def user_account_params
      params.permit(:full_name, :full_phone_number, :email, :password, :password_confirmation, :user_name, :gender, :date_of_birth, :role)
    end

    def user_account_update_params
      params.permit(:full_name, :full_phone_number, :email, :password, :user_name, :gender, :date_of_birth)
    end

    def set_user_account
      @user_account = User::Account.find_by(id: params[:id])
      unless @user_account
        render json:  { errors: ['Account not found'] }, status: :not_found
      end
    end

    def validate_principal
      unless @current_user.role == "principal"
        render json: {errors: ['You dont have permission to do this action']}, status: :unprocessable_entity
      end
    end

  end
end
