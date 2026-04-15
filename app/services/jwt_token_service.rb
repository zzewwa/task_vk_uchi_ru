class JwtTokenService
  def self.encode(student)
    payload = {
      id: student.id,
      jwt_validation: student.jwt_validation,
      created_at: Time.now.to_i
    }

    JWT.encode(payload, "SK", "HS256")
  end

  def self.decode(token)
    JWT.decode(token, nil, false).first
  rescue JWT::DecodeError
    nil
  end
end
