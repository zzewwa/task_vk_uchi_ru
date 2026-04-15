class Student < ApplicationRecord
  belongs_to :school
  belongs_to :school_class, counter_cache: :students_count

  validates :first_name, :last_name, :surname, :jwt_validation, presence: true
end
