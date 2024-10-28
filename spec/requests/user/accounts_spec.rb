require 'rails_helper'

RSpec.describe "/user/accounts", type: :request do
  before(:all) do
    @account = create(:account)
    @token = ::JsonWebToken.encode({id: @account.id})

    create_pair(:account)
  end
  let(:valid_attributes) { attributes_for(:account, full_name: "New user") }

  let(:invalid_attributes) { attributes_for(:account, email: "Invalid email") }

  describe "GET /index" do
    it "renders a successful response" do
      get "/user/accounts", headers: {Authorization: @token}
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    context "with valid account id" do
      it "renders a successful response" do
        get user_account_url(@account), headers: {Authorization: @token}
        expect(response).to be_successful
      end

      it "renders account not found error response" do
        get user_account_url(0), headers: {Authorization: @token}
        expect(response).to have_http_status(:not_found)
        expect(json_response["errors"]).to eq(["Account not found"])
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new User::Account" do
        expect {
          post user_accounts_url, params: valid_attributes, as: :json
        }.to change(User::Account, :count).by(1)
        expect(json_response["data"]["attributes"]["full_name"]).to eq("New user")
      end
    end

    context "with invalid parameters" do
      it "does not create a new User::Account" do
        expect {
          post user_accounts_url, params: { user_account: invalid_attributes }, as: :json }.to change(User::Account, :count).by(0)
        expect(json_response["errors"]).to include("Password can't be blank")
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested user_account" do
        patch user_accounts_url, params: { full_name: "New name" }, headers: {Authorization: @token}, as: :json
        expect(json_response["data"]["attributes"]["full_name"]).to eq("New name")
        @account.reload
        expect(response).to have_http_status(:ok)
        expect(@account.full_name).to eq("New name")
      end
    end

    context "with invalid parameters" do
      it "renders a JSON error response with the user_account" do
        patch user_accounts_url, params: { full_phone_number: "132", email: "Invalid email" }, headers: {Authorization: @token}, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response["errors"]).to eq(["Invalid or Unrecognized Phone Number", "Invalid Email"])
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the current user account" do
      delete user_accounts_url, headers: {Authorization: @token}, as: :json
      expect(response).to have_http_status(:ok)
      expect(json_response["messages"]).to  eq(["Account deleted successfully"])
    end
  end

end
