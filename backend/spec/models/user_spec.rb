require 'rails_helper'

RSpec.describe User do
  describe "validations" do
    context "全て有効の場合" do
      let(:user) { build(:user) }
      it "保存に成功する" do
        expect(user).to be_valid
      end
    end

    context "nameがnilの場合" do
      let(:user) { build(:user, name: nil) }
      it "保存されないこと" do
        user.valid?
        expect(user.errors.full_messages).to include("Nameを入力してください")
      end
    end

    context "emailがnilの場合" do
      let(:user) { build(:user, email: nil) }
      it "保存されないこと" do
        user.valid?
        expect(user.errors.full_messages).to include("Emailを入力してください")
      end
    end

    context "passwordがnilの場合" do
      let(:user) { build(:user, password: nil) }

      it "保存されないこと" do
        user.valid?
        expect(user.errors.full_messages).to include("Passwordを入力してください")
      end
    end

    context "emailが重複している場合" do
      let!(:user) { create(:user, email: "test@example.com") }

      it "保存されないこと" do
        user = build(:user, email: "test@example.com")
        user.valid?
        expect(user.errors.full_messages).to include("Emailはすでに存在します")
      end
    end

    context "passwordが短い場合" do
      let(:user) { build(:user, password: "1234") }
      it "保存されないこと" do
        user.valid?
        expect(user.errors.full_messages).to include("Passwordは6文字以上で入力してください")
      end
    end
  end
end
