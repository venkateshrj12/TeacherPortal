module User
  class AccountsController < User::ApplicationController
    before_action :validate_jwt, except: :create
    before_action :set_user_account, only: %i[ show update destroy ]

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
      render json: @user_account, serializer: AccountSerializer
    end

    # POST /user/accounts
    def create #signup
      begin
        @user_account = User::Account.new(user_account_params)
        if @user_account.save
          expiration = Time.now + 30.days
          auth_token = ::JsonWebToken.encode({id: @user_account.id}, expiration)
          render json: AccountSerializer.new(@user_account, meta: {auth_token: auth_token}), status: :created
        else
          render json: {errors: @user_account.errors.full_messages}, status: :unprocessable_entity
        end
      rescue StandardError => e
        render json: {errors: [e.message]}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /user/accounts/1
    def update
      if @user_account.update(user_account_params)
        render json: @user_account
      else
        render json: @user_account.errors, status: :unprocessable_entity
      end
    end

    # DELETE /user/accounts/1
    def destroy
      @user_account.destroy!
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_account
      @user_account = User::Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_account_params
      params.permit(:full_name, :full_phone_number, :email, :password, :password_confirmation, :user_name, :gender, :date_of_birth)
    end
  end
end
