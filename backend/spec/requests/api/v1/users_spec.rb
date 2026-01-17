require 'rails_helper'
RSpec.describe 'Api::V1::Users', type: :request do
  let (:user) { FactoryBot.create(:user) }
  let(:headers) { authorization_header(user) }

  describe "GET /api/v1/users" do
    context "ログイン済みの場合" do
      it "現在のユーザーを返すこと" do
        get "/api/v1/users", headers: headers
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json["id"]).to eq (user.id)
        expect(json["email"]).to eq (user.email)
        expect(json).not_to have_key("password_digest")
      end
    end

    context "ログインしていない場合" do
      it "unauthorizedが返ること" do
        get "/api/v1/users"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/users" do
    let(:valid_params) { { user: FactoryBot.attributes_for(:user) } }
    let(:invalid_params) { { user: FactoryBot.attributes_for(:user, :invalid_user) } }

    context "有効なパラメータである場合" do
      it "ユーザーが作成できること" do
        expect {
          post "/api/v1/users", params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "無効なパラメータの場合" do
      it "ユーザーが作成できないこと" do
        expect {
          post "/api/v1/users", params: invalid_params
        } .not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "DELETE /api/v1/users" do
    let!(:user) { FactoryBot.create(:user) }

    context "ログインしている場合" do
      it "自身のアカウントを削除できること" do
        expect {
          delete "/api/v1/users/#{user.id}", headers: headers
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Deleted")
      end
    end

    context "ログインしていない場合" do
      it "アカウントを削除できないこと" do
        expect {
          delete "/api/v1/users/#{user.id}"
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unauthorized)
      end
    end

    context "削除に失敗した場合" do
      before do
        allow_any_instance_of(User).to receive(:destroy) do |user_instance|
          user_instance.errors.add(:base, "削除に失敗しました")
          false
        end
      end
      it "ユーザーが削除できないこと" do
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
    let(:update_params) { FactoryBot.attributes_for(:user, :update_user) }
    let(:invalid_params) { FactoryBot.attributes_for(:user, :invalid_user) }

    context "ログインしていて正しいパラメータの場合" do
      it "ユーザーが更新できること" do
        put "/api/v1/users/#{user.id}", params: { user: update_params }, headers: headers
        expect(response).to have_http_status(:ok)

        expect(user.reload.name).to eq("update_name")
      end
    end

    context "ログインしていない場合" do
      it "更新に失敗すること" do
        put "/api/v1/users/#{user.id}", params: { user: update_params }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "不正なパラメータの場合" do
      it "更新に失敗すること" do
        put "/api/v1/users/#{user.id}", params: { user: invalid_params }, headers: headers
        puts JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
