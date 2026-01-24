require 'rails_helper'

RSpec.describe 'Api::V1::Tasks', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user, :other_user) }
  let(:token) { JwtToken.call(user) }
  let(:headers) {{ "Authorization" => "Bearer #{token}" }}

  describe  "GET /api/v1/tasks" do
    let!(:task) { FactoryBot.create(:task, user: user) }
    let!(:other_task) { FactoryBot.create(:task, :other_task, user: other_user) }

    context "認証している場合" do
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
      it "タスクを作成できること" do
        expect{
          post "/api/v1/tasks", headers: headers, params: valid_params
      }.to change(Task, :count).by (1)

        expect(response).to have_http_status(:created)  
      end
    end

    context "認証しており、不正なパラメータの場合" do
      let!(:invalid_params) { { task: FactoryBot.attributes_for(:task, :invalid_task) } }
      it "タスクを作成できないこと" do
        expect{
          post "/api/v1/tasks", headers: headers, params: invalid_params
        }.not_to change(Task, :count)

        expect(response).to have_http_status(:unprocessable_content)  
      end
    end

    context "認証しておらず、正しいパラメータの場合" do
        let!(:valid_params) { { task: FactoryBot.attributes_for(:task)} }
      it "タスクを作成できないこと" do
        expect{
          post "/api/v1/tasks", params: valid_params
      }.not_to change(Task, :count)

      expect(response).to have_http_status(:unauthorized)  
      end
    end

    context "認証しておらず、不正なパラメータの場合" do
      let!(:invalid_params) { { task: FactoryBot.attributes_for(:task, :invalid_task) } }
      it "タスクを作成できないこと" do
        expect{
          post "/api/v1/tasks", params: invalid_params
      }.not_to change(Task, :count)

      expect(response).to have_http_status(:unauthorized)  
      end
    end
  end

  describe "DELETE /api/v1/tasks" do
    let!(:task) { FactoryBot.create(:task, user: user) }
    let!(:other_task) { FactoryBot.create(:task, :other_task, user: other_user) }
    context "自身のタスクを指定した場合" do
      it "削除できること" do
        expect{
          delete "/api/v1/tasks/#{task.id}", headers: headers
      }.to change(Task, :count).by(-1)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("タスクを削除しました")   
      end
    end
    
    context "自身以外のタスクを指定した場合" do
      it "削除できないこと" do
        expect{
          delete "/api/v1/tasks/#{other_task.id}", headers: headers
        }.not_to change(Task, :count)
      end
    end
  end

  describe "PUT /api/v1/tasks" do
    let!(:task) { FactoryBot.create(:task, user: user) }

    context "正常なパラメータの場合" do
      let(:params) { { task: { title: "updatetitle"} } }
      it "更新できること" do
          put "/api/v1/tasks/#{task.id}", params: params, headers: headers 
          expect(response).to have_http_status(:ok)
          expect(task.reload.title).to eq "updatetitle"  
      end
    end

    context "不正なパラメータの場合" do
      let(:invalid_params) { { task: { title: "" } } }
      it "更新に失敗すること" do
        put "/api/v1/tasks/#{task.id}", params: invalid_params, headers: headers
        expect(response).to have_http_status(:unprocessable_content)  
      end
    end
  end
end
