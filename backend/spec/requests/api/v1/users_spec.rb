require 'rails_helper'
RSpec.describe 'Api::V1::Users', type: :request do
  let (:user) { FactoryBot.create(:user) }

  let(:token) do
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    secret_key = Rails.application.credentials.secret_key_base
    JWT.encode(payload, secret_key)
  end

  let(:headers) { { "Authorization" => "Bearer #{token}" } }

  describe "GET /api/v1/users" do
    context "when logged in" do
      it "returns current_user with status ok" do
        get "/api/v1/users", headers: headers
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq (user.id)
        expect(json["email"]).to eq (user.email)
        expect(json).not_to have_key("password_digest")
      end
    end

    context "when not logged in" do
      it "returns unauthorized" do
        get "/api/v1/users"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/users" do
    let(:valid_params) { { user: FactoryBot.attributes_for(:user) } }
    let(:invalid_params) { { user: FactoryBot.attributes_for(:user).merge(name: "") } }

    context "for valid params" do
      it "user created and the returns status ok" do
        expect {
          post "/api/v1/users", params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "for invalid params" do
      it "no user was created and the returns status unprocessable_entity" do
        expect {
          post "/api/v1/users", params: invalid_params
        } .not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /api/v1/users" do
    let!(:user) { FactoryBot.create(:user) }

    context "when logged in" do
      it "deletes the user and returns status ok" do
        expect {
          delete "/api/v1/users/#{user.id}", headers: headers
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Deleted")
      end
    end

    context "when not logged in" do
      it "does not deleted and returns unauthorized" do
        expect {
          delete "/api/v1/users/#{user.id}"
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unauthorized)
      end
    end

    context "deletion failed" do
      before do
        allow_any_instance_of(User).to receive(:destroy) do |user_instance|
          user_instance.errors.add(:base, "削除に失敗しました")
          false
        end
      end
      it "does not deleted and returns unauthorized_entity" do
        expect {
          delete "/api/v1/users/#{user.id}", headers: headers
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)

        json = JSON.parse(response.body)
        expect(json["message"]).to include("削除に失敗しました")
      end
    end
  end

  describe "PUT /api/v1/users" do
    let(:update_params) { { user: { name: "Updated Name" } } }
    let(:invalid_params) { { user: { email: "mail" } } }

    context "when logged in" do
      it "正しいparams" do
        put "/api/v1/users/#{user.id}", params: update_params, headers: headers

        expect(response).to have_http_status(:ok)

        expect(user.reload.name).to eq("Updated Name")
      end
    end

    context "when not logged in" do
      it "failed to update and returned unauthorized" do
        put "/api/v1/users/#{user.id}", params: update_params

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "invalid parameter" do
      it "failed to update and returned unprocessable_content" do
        put "/api/v1/users/#{user.id}", params: invalid_params, headers: headers
        puts JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
