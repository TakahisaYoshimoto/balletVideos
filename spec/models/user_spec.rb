require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  describe 'validation test' do

    before(:each) do
      @user = FactoryGirl.build(:user)
    end

    it 'passwordが6文字以上は有効' do
      @user.password = '123456'
      @user.password_confirmation = '123456'
      expect(@user).to be_valid
    end

    it 'passwordが6文字未満は無効' do
      @user.password = '12345'
      @user.password_confirmation = '12345'
      expect(@user).not_to be_valid
    end

    it 'passwordが異なると無効' do
      @user.password = 'password'
      @user.password_confirmation = 'dorwssap'
      expect(@user).not_to be_valid
    end

  end

end
