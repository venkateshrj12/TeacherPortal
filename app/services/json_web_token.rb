class JsonWebToken
  class << self
    def encode(payload, exp=nil)
      exp = exp || Time.now + 24.hours
      payload[:exp] = exp.to_i
      JWT.encode(payload, secrete_key, algorithm)
    end

    def decode(token)
      token_data = JWT.decode(token, secrete_key, true, {:algorithm => algorithm, })[0]
      HashWithIndifferentAccess.new(token_data)
    end

    def secrete_key
      Rails.application.credentials.secrete_key_base.to_s
    end

    def algorithm
      'HS512'
    end
  end
end