require_relative "../lib/social_network.rb"
require_relative "../lib/user.rb"
require_relative "../lib/tweet.rb"

include MiniTwitter

describe SocialNetwork do

  before :each do
    @sc = SocialNetwork.new
    [User.new(1236, "golfadas1"), User.new(1235, "golfadas2"),User.new(1234, "golfadas")].each do |u|
      @sc.add_user( u )
    end
  end

  it "is a pretty hash, used to store users" do
    @sc.users.size.should eq(3)
  end

  it "behaves like the hash he sort of is" do
    @sc[:golfadas1].name.should eql("golfadas1")
    @sc.size.should eql(3)
  end

  it "adds tweets and new users" do
    @sc.add_user( User.new( 12357, "cobama" ) )
    @sc[:cobama].tweets << Tweet.new( 12345, "OH my god such amazingness"  )
    @sc[:cobama].tweets << Tweet.new( 12346, "I Love justin bieber"  )
    @sc[:cobama].tweets.size.should       eq( 2 )
    @sc[:cobama].tweets.first.text.should eq( "OH my god such amazingness" )
  end

  describe '#total_number_tweets' do
    it "returns the total number of tweets" do
      @sc.total_number_tweets.should eq( 0 )
      @sc.add_user( User.new( 12357, "cobama" ) )
      @sc[:cobama].tweets << Tweet.new( 12345, "OH my god such amazingness"  )
      @sc[:cobama].tweets << Tweet.new( 12346, "I Love justin bieber"  )
      @sc.total_number_tweets.should eq( 2 )
    end
  end

  describe '#user_exists?' do
    it "returns a bollean if a users exists/doesnt exist" do
      @sc.user_exists?( "golfadas1" ).should         be true
      @sc.user_exists?( "non_existing_user" ).should be false
      @sc.user_exists?( 1236 ).should                be true
      @sc.user_exists?( 9999 ).should                be false
    end
  end

  describe '#crawled_users_ids' do
    it "returns an array with ids of the crawled users" do
     @sc.crawled_users_ids.should include(1236,1235,1234)
    end
  end

  describe '#friends_of_crawled_users_ids' do
    it "returns a set with the IDS of all the followers of the crawled users" do
      @sc.add_user User.new( 12348, "blabla", [], [12345,123456,1234567] )
      @sc.add_user User.new( 99999, "blabl2", [], [12348,123459,1234570] )
      @sc.friends_of_crawled_users_ids.should include(12345,123456,1234567,12348,123459,1234570)
    end
  end

  describe '#users_to_crawl' do
    it "returns a set with users that do not exist in the network, but are friends of someone" do
      @sc.add_user( User.new( 12348, "blabla", [], [12345,123456,1234567] ) )
      @sc.add_user( User.new( 99999, "blabl2", [], [12348,123459,1234570] ) )
      # 12348 should not be included in the set, because blabl2 is following blabla
      @sc.users_to_crawl.should include( 12345,123456,1234567,123459,1234570)
    end
  end

  describe '#marshal! and #unmarshal!' do
    it "serializes and saves the class to disk" do
      @sc.add_user( User.new( 12348, "blabla", [], [12345,123456,1234567] ) )
      @sc.add_user( User.new( 99999, "blabl2", [], [12348,123459,1234570] ) )
      @sc_old = @sc
      file_path = @sc.marshal!
      File.exists?( file_path ).should be true
      @sc2 = @sc.unmarshal!( file_path )
      @sc2.to_s.should eql @sc.to_s
      @sc_old.to_s.should eql @sc.to_s
      File.delete( file_path )
    end
  end

  describe '#to_s' do
    it "prints a resume of the social network" do
      @sc.to_s.should eq "      total number of tweets:\t\t0\n      total number of users:\t\t3\n      total number of followers detected:\t\t0\n"
    end
  end
end
