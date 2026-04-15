require "jwt"

class ApplicationController < ActionController::API
	AUTH_TOKEN_OFFSET = 7

	rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
	rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
	rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found

	private

	def ensure_authorized
		return render_error(status: :unauthorized, code: :unauthorized, errors: { auth: ["Authorization header is missing"] }) unless check_token
		return render_error(status: :unauthorized, code: :unauthorized, errors: { auth: ["Invalid authorization format"] }) unless request.headers["Authorization"].start_with?("Bearer ")

		decoded_token = decode_token(request.headers["Authorization"][AUTH_TOKEN_OFFSET..])
		return render_error(status: :unauthorized, code: :unauthorized, errors: { auth: ["Invalid token"] }) if decoded_token.nil?

		@current_student = Student.find_by(id: decoded_token["id"], jwt_validation: decoded_token["jwt_validation"])
		return if @current_student.present?

		render_error(status: :unauthorized, code: :unauthorized, errors: { auth: ["Unauthorized"] })
	end

	def render_interactor_result(result)
		if result.success?
			result.headers.each { |k, v| response.set_header(k, v) }
			return head(result.status) if result.data.blank?

			render json: result.data, status: result.status
		else
			render_error(status: result.status, code: result.error_code, errors: result.errors)
		end
	end

	def render_error(status:, code:, errors: {})
		render json: { error_code: code, errors: errors }, status: status
	end

	def check_token
		request.headers["Authorization"].present?
	end

	def decode_token(token)
		JwtTokenService.decode(token)
	end

	def render_parameter_missing(exception)
		render_error(status: :bad_request, code: :bad_request, errors: { exception.param => ["is missing"] })
	end

	def render_record_invalid(exception)
		render_error(status: :bad_request, code: :record_invalid, errors: exception.record.errors.to_hash)
	end

	def render_record_not_found(exception)
		render_error(status: :not_found, code: :not_found, errors: { exception.model.underscore => ["not found"] })
	end
end
