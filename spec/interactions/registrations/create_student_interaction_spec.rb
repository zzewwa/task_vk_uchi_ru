require "rails_helper"

RSpec.describe Registrations::CreateStudentInteractor do
  describe "#call" do
    it "creates student and returns created result with token header" do
      school = create(:school)
      school_class = create(:school_class, school: school)

      result = described_class.new(
        params: {
          first_name: "Petr",
          last_name: "Petrov",
          surname: "Petrovich",
          school_id: school.id,
          class_id: school_class.id
        }
      ).call

      expect(result).to be_success
      expect(result.status).to eq(:created)
      expect(result.headers["X-Auth-Token"]).to be_present
      expect(result.data[:first_name]).to eq("Petr")
    end

    it "returns failure for invalid school/class pair" do
      result = described_class.new(
        params: {
          first_name: "Petr",
          last_name: "Petrov",
          surname: "Petrovich",
          school_id: 999_999,
          class_id: 999_999
        }
      ).call

      expect(result).not_to be_success
      expect(result.status).to eq(:method_not_allowed)
      expect(result.error_code).to eq(:invalid_input)
      expect(result.errors).to have_key(:school_or_class)
    end
  end
end
