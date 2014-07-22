require_relative "../lib/user"
require_relative "../lib/tweet.rb"

include MiniTwitter

describe User do
  before :each do
   @u = User.new( 12345, "golfadas" )
  end
  it "initializes itself and has accessible atributes" do
     @u.id.should   eql( 12345 )
     @u.name.should eql( "golfadas")
  end
  it "receaves a couple of tweets" do
    @u.tweets << Tweet.new( 12345, "ola adeus" )
    @u.tweets << Tweet.new( 12346, "foo bar" )
    @u.tweets.size.should         be(2)
    @u.tweets.first.text.should   eql("ola adeus")
  end
  it "receaves a couple of tweets" do
    @u.tweets << Tweet.new( 12345, "ola adeus" )
    @u.tweets << Tweet.new( 12346, "foo bar" )
    @u.tweets.size.should         be(2)
    @u.tweets.first.text.should   eql("ola adeus")
  end
end
