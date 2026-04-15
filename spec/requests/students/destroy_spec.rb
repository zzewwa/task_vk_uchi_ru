require "rails_helper"

RSpec.describe "DELETE /students/:user_id", type: :request do
  def auth_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end

  it "destroys current authorized student" do
    student = create(:student)

    expect do
      delete "/students/#{student.id}", headers: auth_headers(JwtTokenService.encode(student))
    end.to change(Student, :count).by(-1)

    expect(response).to have_http_status(:ok)
  end

  it "returns unauthorized when deleting another student" do
    school = create(:school)
    school_class = create(:school_class, school: school)
    current_student = create(:student, school: school, school_class: school_class)
    another_student = create(:student, school: school, school_class: school_class)

    delete "/students/#{another_student.id}", headers: auth_headers(JwtTokenService.encode(current_student))

    expect(response).to have_http_status(:unauthorized)
    body = JSON.parse(response.body)
    expect(body["error_code"]).to eq("unauthorized")
  end

  it "returns bad_request for invalid student id" do
    student = create(:student)

    delete "/students/999999", headers: auth_headers(JwtTokenService.encode(student))

    expect(response).to have_http_status(:bad_request)
    body = JSON.parse(response.body)
    expect(body["error_code"]).to eq("bad_request")
    expect(body["errors"]).to have_key("user_id")
  end
end
