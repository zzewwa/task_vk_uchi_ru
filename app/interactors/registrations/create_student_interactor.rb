module Registrations
  class CreateStudentInteractor < ApplicationInteractor
    def initialize(params:)
      @params = params
    end

    def call
      school = School.find_by(id: @params[:school_id])
      school_class = SchoolClass.find_by(id: @params[:class_id], school_id: @params[:school_id])

      if school.nil? || school_class.nil?
        return failure(
          error_code: :invalid_input,
          errors: { school_or_class: ["Invalid school or class"] },
          status: :method_not_allowed
        )
      end

      student = Student.new(
        first_name: @params[:first_name],
        last_name: @params[:last_name],
        surname: @params[:surname],
        jwt_validation: ToolsService.random_string(32),
        school: school,
        school_class: school_class
      )

      unless student.save
        return failure(
          error_code: :invalid_input,
          errors: student.errors.to_hash,
          status: :method_not_allowed
        )
      end

      token = JwtTokenService.encode(student)
      success(
        data: StudentSerializer.call(student),
        status: :created,
        headers: { "X-Auth-Token" => token }
      )
    end
  end
end
