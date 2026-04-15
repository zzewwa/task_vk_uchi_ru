FactoryBot.define do
  factory :student do
    association :school_class
    school { school_class.school }
    first_name { "Ivan" }
    last_name { "Ivanovich" }
    surname { "Petrov" }
    jwt_validation { ToolsService.random_string(32) }
  end
end
