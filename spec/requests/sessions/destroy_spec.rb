require "rails_helper"

RSpec.describe "DELETE /session", type: :request do
  def auth_headers(token)
    { "Authorization" => "Bearer #{token}" }
  end

  it "invalidates previous token" do
    student = create(:student)
    old_jwt_validation = student.jwt_validation
    token = JwtTokenService.encode(student)

    delete "/session", headers: auth_headers(token)

    expect(response).to have_http_status(:ok)
    expect(student.reload.jwt_validation).not_to eq(old_jwt_validation)

    get "/schools/#{student.school_id}/classes", headers: auth_headers(token)
    expect(response).to have_http_status(:unauthorized)
  end
end
