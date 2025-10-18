require 'rails_helper'

RSpec.describe User do
  describe "validations" do
    context "全て有効の場合" do
      let(:user) {build(:user)}
      it "保存に成功する" do
        expect(user).to be_valid
      end
    end


  end
end

