require 'rails_helper'

RSpec.describe ApplicationController, type: :request do
  before(:all) do
    @account = create(:account)
    @token = ::JsonWebToken.encode({id: @account.id}, Time.now + 10.minutes)
  end

  describe "Not Found /*" do
    it "returns a 404 status code" do
      get "/invalid_url"
      expect(response).to have_http_status(:not_found)
      expect(json_response["errors"]).to eq(["Page not found"])
    end
  end

  describe "Token  Validation" do
    it "returns unauthorized status code when token is expired" do
      Timecop.travel(10.days.from_now)
      get "/user/accounts", headers: {Authorization: @token}
      expect(response).to have_http_status(:unauthorized)
      expect(json_response["errors"]).to eq(['Session Expired, Login again'])
    end

    it "returns bad_request status code when token is invalid" do
      get "/user/accounts", headers: {Authorization: "Bearer invalid_token"}
      expect(response).to have_http_status(:bad_request)
      expect(json_response["errors"]).to eq(['Invalid token. Log in for a new one.'])
    end
  end

end