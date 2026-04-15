require "rails_helper"

RSpec.describe "GET /schools/:school_id/classes", type: :request do
  def auth_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end

  it "requires authorization" do
    school = create(:school)

    get "/schools/#{school.id}/classes"

    expect(response).to have_http_status(:unauthorized)
    body = JSON.parse(response.body)
    expect(body["error_code"]).to eq("unauthorized")
  end

  it "returns classes list for authorized student" do
    school = create(:school)
    school_class = create(:school_class, school: school)
    student = create(:student, school: school, school_class: school_class)

    get "/schools/#{school.id}/classes", headers: auth_headers(JwtTokenService.encode(student))

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["data"]).to be_an(Array)
    expect(body["data"]).not_to be_empty
  end
end
