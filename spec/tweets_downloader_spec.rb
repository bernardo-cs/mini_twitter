require_relative "../lib/tweets_downloader.rb"
require_relative "../lib/user.rb"

include MiniTwitter

describe TweetsDownloader do
  before :each do
    @td = TweetsDownloader.new( ENV['THESIS_TWITTER_DEV_KEY'],
                               ENV['THESIS_TWITTER_DEV_SECRET'],
                               ENV['THESIS_TWITTER_DEV_ACCESS_TOKEN'],
                               ENV['THESIS_TWITTER_DEV_ACCESS_TOKEN_SECRET'])
      @tweets = @td.fetch_user_tweets( "golfadas" )
  end

  describe '#twitter_catcher_main_block' do
    it "creates a space where is possible to intract with the twitter API and achieve rate limits safelly" do
      @td.twitter_catcher_main_block do |td|
        td.client.follower_ids.to_a.each{ |t| t.should be_kind_of Integer }
      end
    end
  end

  describe '#fetch_user_tweets' do
    it "fetches a user tweets" do
      @tweets.size.should be > 0
      @tweets.each{ |t| t.should be_kind_of Twitter::Tweet }
    end
  end

  describe '#create_user' do
    it "creates a local user, with his tweets as followers" do
      u = @td.create_user( @tweets )
      u.tweets.size.should be > 0
      u.followers.size.should be   > 0
      u.name.should eql "golfadas"
      u.id.should   eql(39513233)
    end
  end

  describe '#crawl_user' do
    it "fetches a remote user by username and stores it in the SocialNetwork" do
      @td.sn = SocialNetwork.new
      @td.crawl_user( "golfadas" )
      @td.sn.user_exists?( "golfadas" ).should be true
      @td.sn.total_number_users.should eql 1
      @td.sn[:golfadas].should be_kind_of User
      @td.sn[:golfadas].tweets.size.should be > 0
      @td.sn[:golfadas].followers.size.should be > 0
      @td.sn[:golfadas].followers.each{ |f| f.should be_kind_of Fixnum }
    end
  end

  describe '#crawl_seed' do
    it "crawls the users in the seed set" do
      @td.twitter_catcher_main_block do |td|
        td.crawl_seed
      end
      @td.sn.user_exists?("tenderlove").should     be true
      @td.sn.user_exists?("EllenPage").should      be true
      @td.sn.user_exists?("BarackObama").should    be true
      @td.sn.user_exists?("pitchforkmedia").should be true
      @td.sn.total_number_tweets.should be > 0
    end
  end
end
