# require 'spec_helper'
require 'rails_helper'

describe YoutubeVideo do

  it 'has a valid factory' do
    expect(FactoryGirl.build(:youtube_video)).to be_valid
  end

  describe '必須項目のテスト' do

    before(:each) do
      @youtube_video = FactoryGirl.build(:youtube_video)
    end

    it 'title' do
      @youtube_video.title = nil
      expect(@youtube_video).not_to be_valid
    end

    it 'url' do
      @youtube_video.url = nil
      expect(@youtube_video).not_to be_valid
    end

    it 'category' do
      @youtube_video.url = nil
      expect(@youtube_video).not_to be_valid
    end

  end

end
