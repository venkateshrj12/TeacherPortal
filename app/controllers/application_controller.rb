class ApplicationController < ActionController::API
  before_action :set_pagination_data

  def not_found
    render json: { error: 'not_found' }, status: :not_found
  end

  def validate_jwt
    auth_token = request.headers['Authorization']
    begin
      @token = JsonWebToken.decode(auth_token)
      @current_user = User::Account.find_by_id(@token[:id])
      raise JWT::DecodeError unless @current_user
    rescue JWT::ExpiredSignature
        return render json: { errors: ['Session Expired, Login again'] }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { errors: ['Invalid token. Log in for a new one.'] }, status: :bad_request
    end
  end

  private

  def set_pagination_data
    @page = params.fetch("page", 1)&.to_i
    @per_page = params.fetch("per_page", 20)&.to_i
  end

  def pagination_details(records)
    total_records = records.total_count
    records_count = records.count
  
    {
      page: @page,
      records: records_count,
      total_records: total_records,
      total_pages: records_count.zero? ? 0 : (total_records.to_f / records_count).ceil
    }
  end
end
