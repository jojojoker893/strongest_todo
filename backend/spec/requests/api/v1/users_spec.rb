require 'rails_helper'
RSpec.describe 'Api::V1::Users', type: :request do

  describe "POST /api/v1/users" do
    context "有効なパラメータである場合" do
      let!(:valid_params) { { user: FactoryBot.attributes_for(:user)} } 
      it "ユーザーが作成できること" do
        expect {
          post "/api/v1/users", params: valid_params
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "無効なパラメータの場合" do
      let!(:invalid_params) { { user: FactoryBot.attributes_for(:user, :invalid_user) } }
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

    context "認証している場合" do
      let(:token) { JwtToken.call(user) }
      let(:headers) {{ "Authorization" => "Bearer #{token}" }}
      it "自身のアカウントを削除できること" do
        expect {
          delete "/api/v1/users/#{user.id}", headers: headers
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Deleted")
      end
    end

    context "認証していない場合" do
      it "アカウントを削除できないこと" do
        expect {
          delete "/api/v1/users/#{user.id}"
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /api/v1/users" do
    let!(:user) { FactoryBot.create(:user) }

    context "認証していて正しいパラメータの場合" do
      let(:update_params) { FactoryBot.attributes_for(:user, :update_user) }
      let(:token) { JwtToken.call(user) }
      let(:headers) {{ "Authorization" => "Bearer #{token}" }}
      it "ユーザーが更新できること" do
        put "/api/v1/users/#{user.id}", params: { user: update_params }, headers: headers
        expect(response).to have_http_status(:ok)

        expect(user.reload.name).to eq("update_name")
      end
    end

    context "認証していない場合" do
      let(:update_params) { FactoryBot.attributes_for(:user, :update_user) }
      it "更新に失敗すること" do
        put "/api/v1/users/#{user.id}", params: { user: update_params }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "不正なパラメータの場合" do
      let(:invalid_params) { FactoryBot.attributes_for(:user, :invalid_user) }
      let(:token) { JwtToken.call(user) }
      let(:headers) {{ "Authorization" => "Bearer #{token}" }}
      it "更新に失敗すること" do
        put "/api/v1/users/#{user.id}", params: { user: invalid_params }, headers: headers
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
