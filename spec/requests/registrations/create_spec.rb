require "rails_helper"

RSpec.describe "POST /students", type: :request do
  it "registers student and returns auth token" do
    school = create(:school)
    school_class = create(:school_class, school: school)

    post "/students", params: {
      first_name: "Petr",
      last_name: "Petrov",
      surname: "Petrovich",
      school_id: school.id,
      class_id: school_class.id
    }

    expect(response).to have_http_status(:created)
    expect(response.headers["X-Auth-Token"]).to be_present

    body = JSON.parse(response.body)
    expect(body["first_name"]).to eq("Petr")
    expect(body["school_id"]).to eq(school.id)
    expect(body["class_id"]).to eq(school_class.id)
  end

  it "returns method_not_allowed for invalid school or class" do
    post "/students", params: {
      first_name: "Petr",
      last_name: "Petrov",
      surname: "Petrovich",
      school_id: 999_999,
      class_id: 999_999
    }

    expect(response).to have_http_status(:method_not_allowed)

    body = JSON.parse(response.body)
    expect(body["error_code"]).to eq("invalid_input")
    expect(body["errors"]).to have_key("school_or_class")
  end
end
