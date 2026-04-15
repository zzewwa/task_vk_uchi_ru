class SessionsController < ApplicationController
  before_action :ensure_authorized, only: [:destroy]

  def create
    result = Sessions::CreateInteractor.new(
      first_name: session_params[:first_name],
      last_name: session_params[:last_name],
      surname: session_params[:surname]
    ).call
    render_interactor_result(result)
  end

  def destroy
    result = Sessions::DestroyInteractor.new(current_student: @current_student).call
    render_interactor_result(result)
  end

  private

  def session_params
    params.permit(:first_name, :last_name, :surname)
  end
end
