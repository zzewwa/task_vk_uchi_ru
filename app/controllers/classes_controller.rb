class ClassesController < ApplicationController
  before_action :ensure_authorized

  def index
    result = Classes::ListBySchoolInteractor.new(school_id: params[:school_id]).call
    render_interactor_result(result)
  end
end
