require_relative "../lib/tweet.rb"

describe Tweet do
   it "creates a tweet" do
     t = Tweet.new( 123456, "Ho my god justinbiebr rocks")
     t.id.should           eq( 123456)
     t.text.should         eq( "Ho my god justinbiebr rocks" )
     t.trimmed_text.should eq( "god justinbiebr rock")
   end
end
