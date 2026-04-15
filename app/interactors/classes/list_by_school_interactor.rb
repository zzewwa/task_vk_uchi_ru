module Classes
  class ListBySchoolInteractor < ApplicationInteractor
    def initialize(school_id:)
      @school_id = school_id
    end

    def call
      classes = SchoolClass.where(school_id: @school_id).order(:id)
      success(data: { data: classes.map { |school_class| SchoolClassSerializer.call(school_class) } }, status: :ok)
    end
  end
end
