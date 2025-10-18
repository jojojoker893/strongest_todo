require 'rails_helper'

RSpec.describe User do
  describe "validations" do
    context "全て有効の場合" do
      let(:user) {build(:user)}
      it "保存に成功する" do
        expect(user).to be_valid
      end
    end

    context "nameがnilの場合" do
      let(:user) {build(:user, name: nil)}
      it "保存されないこと" do
        is_valid = user.valid?

        expect(is_valid).to be false
        expect(user.errors[:name]).to include("can't be blank")  
      end
    end
    
    context "emailがnilの場合" do
      let(:user) {build(:user, email: nil)}
      it "保存されないこと" do
        is_valid = user.valid?

        expect(is_valid).to be false
        expect(user.errors[:email]).to include("can't be blank")   
      end
    end
    
    context "passwordがnilの場合" do
      let(:user) {build(:user, password: nil)}

      it "保存されないこと" do
        is_valid = user.valid?

        expect(is_valid).to be false
        expect(user.errors[:password]).to include("can't be blank")    
      end
    end

    context "emailが重複している場合" do
      let!(:user) {create(:user, email: "test@example.com")}

      it "保存されないこと" do
        user = build(:user, email: "test@example.com")
        user.valid?
        expect(user.errors[:email]).to include("has already been taken")
      end
    end
    
    context "passwordが短い場合" do
      let(:user) {build(:user, password: "1234")}
      it "保存されないこと" do
        user.valid?
        expect(user.errors[:password]).to  include("is too short (minimum is 6 characters)")
      end
      
    end
    
    


  end
end

