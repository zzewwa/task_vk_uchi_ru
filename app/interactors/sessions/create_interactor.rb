module Sessions
  class CreateInteractor < ApplicationInteractor
    def initialize(first_name:, last_name:, surname:)
      @first_name = first_name
      @last_name = last_name
      @surname = surname
    end

    def call
      missing_fields = {}
      missing_fields[:first_name] = ["is required"] if @first_name.blank?
      missing_fields[:last_name] = ["is required"] if @last_name.blank?
      missing_fields[:surname] = ["is required"] if @surname.blank?

      return failure(error_code: :bad_request, errors: missing_fields, status: :bad_request) if missing_fields.any?

      student = Student.where(
        first_name: @first_name,
        last_name: @last_name,
        surname: @surname
      ).order(id: :desc).first
      return failure(error_code: :bad_request, errors: { auth: ["Invalid credentials"] }, status: :bad_request) if student.nil?

      success(data: { token: JwtTokenService.encode(student) }, status: :ok)
    end
  end
end
