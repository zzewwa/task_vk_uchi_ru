FactoryBot.define do
  factory :school_class do
    association :school
    number { 1 }
    letter { "A" }
    students_count { 0 }
  end
end
