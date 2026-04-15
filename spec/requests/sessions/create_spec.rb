require "rails_helper"

RSpec.describe "POST /session", type: :request do
  it "creates session token for existing student" do
    student = create(:student)

    post "/session", params: {
      first_name: student.first_name,
      last_name: student.last_name,
      surname: student.surname
    }

    expect(response).to have_http_status(:ok)
    body = JSON.parse(response.body)
    expect(body["token"]).to be_present
  end

  it "returns bad_request for unknown fio" do
    post "/session", params: {
      first_name: "Unknown",
      last_name: "Student",
      surname: "Name"
    }

    expect(response).to have_http_status(:bad_request)
    body = JSON.parse(response.body)
    expect(body["error_code"]).to eq("bad_request")
    expect(body["errors"]).to have_key("auth")
  end

  it "returns bad_request when required fields are missing" do
    post "/session", params: { first_name: "", last_name: "", surname: "" }

    expect(response).to have_http_status(:bad_request)
    body = JSON.parse(response.body)
    expect(body["error_code"]).to eq("bad_request")
    expect(body["errors"]).to have_key("first_name")
    expect(body["errors"]).to have_key("last_name")
    expect(body["errors"]).to have_key("surname")
  end
end
