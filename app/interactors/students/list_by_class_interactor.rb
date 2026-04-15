module Students
  class ListByClassInteractor < ApplicationInteractor
    def initialize(school_id:, class_id:)
      @school_id = school_id
      @class_id = class_id
    end

    def call
      school = School.find_by(id: @school_id)
      return success(data: { data: [] }, status: :ok) if school.nil?

      students = Student.where(school_id: school.id, school_class_id: @class_id).order(:id)
      success(data: { data: students.map { |student| StudentSerializer.call(student) } }, status: :ok)
    end
  end
end
