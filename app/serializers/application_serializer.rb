class ApplicationSerializer
  include FastJsonapi::ObjectSerializer
  
  def base_url
    ENV['BASE_URL'] || 'localhost:3000'
  end
end