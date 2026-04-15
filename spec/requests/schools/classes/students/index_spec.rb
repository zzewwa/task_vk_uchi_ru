require "rails_helper"

RSpec.describe "GET /schools/:school_id/classes/:class_id/students", type: :request do
  def auth_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end

  it "returns students list for authorized student" do
    school = create(:school)
    school_class = create(:school_class, school: school)
    student = create(:student, school: school, school_class: school_class)

    get "/schools/#{school.id}/classes/#{school_class.id}/students", headers: auth_headers(JwtTokenService.encode(student))

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["data"]).to be_an(Array)
    expect(body["data"].first["id"]).to eq(student.id)
  end

  it "returns empty list for unknown school" do
    school = create(:school)
    school_class = create(:school_class, school: school)
    student = create(:student, school: school, school_class: school_class)

    get "/schools/999999/classes/#{school_class.id}/students", headers: auth_headers(JwtTokenService.encode(student))

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["data"]).to eq([])
  end
end
