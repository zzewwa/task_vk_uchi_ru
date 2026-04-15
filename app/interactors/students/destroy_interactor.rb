module Students
  class DestroyInteractor < ApplicationInteractor
    def initialize(current_student:, user_id:)
      @current_student = current_student
      @user_id = user_id
    end

    def call
      student = Student.find_by(id: @user_id)
      return failure(error_code: :bad_request, errors: { user_id: ["Invalid student id"] }, status: :bad_request) if student.nil?
      return failure(error_code: :unauthorized, errors: { auth: ["Unauthorized"] }, status: :unauthorized) unless @current_student.id == student.id

      student.destroy!
      success(status: :ok)
    end
  end
end
