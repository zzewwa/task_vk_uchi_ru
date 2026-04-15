class StudentsController < ApplicationController
  before_action :ensure_authorized

  def destroy
    result = Students::DestroyInteractor.new(current_student: @current_student, user_id: params[:user_id]).call
    render_interactor_result(result)
  end

  def index
    result = Students::ListByClassInteractor.new(school_id: params[:school_id], class_id: params[:class_id]).call
    render_interactor_result(result)
  end
end
