require "rails_helper"

RSpec.describe Sessions::CreateInteractor do
  describe "#call" do
    it "returns token for existing student" do
      student = create(:student)

      result = described_class.new(
        first_name: student.first_name,
        last_name: student.last_name,
        surname: student.surname
      ).call

      expect(result).to be_success
      expect(result.status).to eq(:ok)
      expect(result.data[:token]).to be_present
    end

    it "returns bad_request for unknown fio" do
      result = described_class.new(
        first_name: "Unknown",
        last_name: "Student",
        surname: "Name"
      ).call

      expect(result).not_to be_success
      expect(result.status).to eq(:bad_request)
      expect(result.error_code).to eq(:bad_request)
      expect(result.errors).to have_key(:auth)
    end

    it "returns bad_request when required fields are missing" do
      result = described_class.new(first_name: nil, last_name: "", surname: nil).call

      expect(result).not_to be_success
      expect(result.status).to eq(:bad_request)
      expect(result.error_code).to eq(:bad_request)
      expect(result.errors).to have_key(:first_name)
      expect(result.errors).to have_key(:last_name)
      expect(result.errors).to have_key(:surname)
    end
  end
end
