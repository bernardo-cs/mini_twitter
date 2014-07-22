module MiniTwitter
  require_relative "./marshable.rb"
  require 'set'

  class SocialNetwork
    include Marshable
    attr_accessor :users

    def initialize(*args)
      @users = {}
    end

    def add_user user
      @users[user.name.to_sym] = user unless user_exists?( user.name )
    end

    def user_exists? user_name
      user_name.class == String ? @users.has_key?( user_name.to_sym ) : user_exists_by_id?( user_name )
    end

    def total_number_tweets
      @users.inject(0){ |sum, e| sum +=  e.last.tweets.count }
    end

    def total_number_users
      @users.size
    end

    def crawled_users_ids
      @users.inject(Set.new){ |sum,u| sum << u.last.id }
    end

    def friends_of_crawled_users_ids
      @users.inject(Set.new){ |sum,u| sum.merge( u.last.followers ) }
    end

    def users_to_crawl
      friends_of_crawled_users_ids.subtract( crawled_users_ids )
    end

    def to_s
      <<-EOF
      total number of tweets:\t\t#{total_number_tweets}
      total number of users:\t\t#{total_number_users}
      total number of followers detected:\t\t#{friends_of_crawled_users_ids.size}
      EOF
    end

    private
    def method_missing(meth, *args, &block)
      @users.send(meth, *args, &block)
    end

    def user_exists_by_id? uid
      crawled_users_ids.detect{ |n| n== uid }.nil? ? false : true
    end
  end
end
