module Sessions
  class DestroyInteractor < ApplicationInteractor
    def initialize(current_student:)
      @current_student = current_student
    end

    def call
      @current_student.update!(jwt_validation: ToolsService.random_string(32))
      success(status: :ok)
    end
  end
end
