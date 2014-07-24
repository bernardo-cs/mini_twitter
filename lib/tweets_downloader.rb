require_relative "../../data_parser/lib/data_parser"
require_relative "./social_network.rb"
require_relative "./user.rb"
require_relative "./tweet.rb"
require 'set'
require "twitter"

module MiniTwitter

  class TweetsDownloader
    MAX_ATTEMPTS = 300000
    SN_SEEDS_DUMP = '../frozen_storage/MiniTwitter::SocialNetwork2014-07-22T10:26:42Z.txt'
    attr_accessor :sn, :client

    def initialize(*args, unmarshal_social_network: true)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key        = args[0] || ENV['THESIS_TWITTER_KEY']
        config.consumer_secret     = args[1] || ENV['THESIS_TWITTER_SECRET']
        config.access_token        = args[2] || ENV['THESIS_TWITTER_ACCESS_TOKEN']
        config.access_token_secret = args[3] || ENV['THESIS_TWITTER_ACCESS_TOKEN_SECRET']
      end
      ## Seed users info:
      #  name          , info                    , tweets number , following , followers
      #  tenderlove    , senõr programmer        , 30.6k         , 471       , 21.9k
      #  pitchforkmedi , independent music guide , 34.7k         , 2m        , 2.5M
      #  EllenPage     , actress                 , 2m            , 359       , 1.03M
      #  BarackObama   , politician              , 12.1k         , 649       , 44.1M
      #@seed = ( args[0] if args.size == 1 ) || [ "tenderlove", "pitchforkmedia", "EllenPage", "BarackObama"]
      @seed = ( args[0] if args.size == 1 ) || Set.new([14761655,14089195,255747911,813286])
      @sn = SocialNetwork.new
      @unacessible_users_ids = Set.new
      unmarshal_social_network! if unmarshal_social_network
    end

    def twitter_catcher_main_block serialize_on_rate_limit = false, &block
      num_attempts = 0
      begin
        num_attempts += 1
        yield self
      rescue Twitter::Error::TooManyRequests => error
        if num_attempts <= MAX_ATTEMPTS
          puts "Rate limit reached, waiting 15min...",
               "Social network state: ",
               @sn.to_s
          @sn.marshal! if serialize_on_rate_limit
          sleep error.rate_limit.reset_in
          puts "retrying...."
          retry
        else
          raise
        end
      end
    end

    #TODO crawl should not receive the first argument
    #     it should know if the social network is empty or
    #     if it was unmarshaled
    def crawl users_to_crawl = @seed, infinity:  false, serialize_on_rate_limit: false
      user =  users_to_crawl.to_a.sample
      twitter_catcher_main_block( serialize_on_rate_limit ) do
        crawl_user( user )
        users_to_crawl = @sn.users_to_crawl    if infinity
        crawl( users_to_crawl.delete( user ) ) if users_to_crawl.size > 0
      end
    end

    def crawl_user username
      unless @sn.user_exists?( username )
        tweets = fetch_user_tweets( username )
        @sn.add_user create_user( tweets )
      end
    end

    def crawl_seed
      @seed.each{ |s| crawl_user( s ) }
    end

    def fetch_user_tweets username
      @client.user_timeline(username,count: 200, exclude_replies: true, include_rts: false)
    end

    def create_user tweets
      tweet_user   = tweets.first.user
      local_tweets = tweets.inject( [] ){ |sum, t| sum << Tweet.new( t.id, t.text ) }
      followers    = @client.follower_ids( tweet_user.screen_name ).take(50).to_a
      User.new( tweet_user.id, tweet_user.screen_name, local_tweets, followers )
    end

    private
    def unmarshal_social_network!
      @sn = @sn.unmarshal!( SN_SEEDS_DUMP  ) if File.exist?( SN_SEEDS_DUMP )
    end
  end
end
