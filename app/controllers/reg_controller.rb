class RegController < ApplicationController
  def create
    result = Registrations::CreateStudentInteractor.new(params: student_params.to_h.symbolize_keys).call
    render_interactor_result(result)
  end

  private

  def student_params
    params.permit(:first_name, :last_name, :surname, :school_id, :class_id)
  end
end
