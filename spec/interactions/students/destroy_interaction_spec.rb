require "rails_helper"

RSpec.describe Students::DestroyInteractor do
  describe "#call" do
    it "destroys current student" do
      student = create(:student)

      expect do
        result = described_class.new(current_student: student, user_id: student.id).call
        expect(result).to be_success
        expect(result.status).to eq(:ok)
      end.to change(Student, :count).by(-1)
    end

    it "returns unauthorized for another student id" do
      school = create(:school)
      school_class = create(:school_class, school: school)
      current_student = create(:student, school: school, school_class: school_class)
      another_student = create(:student, school: school, school_class: school_class)

      result = described_class.new(current_student: current_student, user_id: another_student.id).call

      expect(result).not_to be_success
      expect(result.status).to eq(:unauthorized)
      expect(result.error_code).to eq(:unauthorized)
    end
  end
end
