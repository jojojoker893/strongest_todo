require 'rails_helper'

RSpec.describe 'Api::V1::Tasks', type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other_user) { FactoryBot.create(:user, :other_user) }
  describe  "GET /api/v1/tasks" do
    let!(:task) { FactoryBot.create(:task, user: user) }
    let!(:other_task) { FactoryBot.create(:task, :other_task, user: other_user) }

    context "認証している場合" do
      let(:token) { JwtToken.call(user) }
      let(:headers) {{ "Authorization" => "Bearer #{token}" }}
      it "自身のタスクのみ取得できること" do
        get "/api/v1/tasks", headers: headers
        expect(response).to have_http_status(:ok)
        
        json = JSON.parse(response.body)
        expect(json["tasks"][0]["id"]).to eq(task.id)

        other_id = json["tasks"].map { |i| i["id"] }
        expect(other_id).not_to include (other_task.id)  
      end
    end
  end

  describe "POST /api/v1/tasks" do
    context "認証しており、正しいパラメータの場合" do
      let!(:valid_params) { { task: FactoryBot.attributes_for(:task)} }
      let(:token) { JwtToken.call(user) }
      let(:headers) {{ "Authorization" => "Bearer #{token}" }}
      it "タスクを作成できること" do
        expect{
          post "/api/v1/tasks", headers: headers, params: valid_params
      }.to change(Task, :count).by (1)

        expect(response).to have_http_status(:created)  
      end
    end

    context "認証しており、不正なパラメータの場合" do
      let!(:invalid_params) { { task: FactoryBot.attributes_for(:task, :invalid_task) } }
      let(:token) { JwtToken.call(user) }
      let(:headers) {{ "Authorization" => "Bearer #{token}" }}
      it "タスクを作成できないこと" do
        expect{
          post "/api/v1/tasks", headers: headers, params: invalid_params
        }.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_entity)  
      end
    end

    context "認証しておらず、正しいパラメータの場合" do
      it "タスクを作成できないこと" do
        
      end
    end

    context "認証しておらず、不正なパラメータの場合" do
      it "タスクを作成できないこと" do
        
      end
    end
    
  end
  
end



