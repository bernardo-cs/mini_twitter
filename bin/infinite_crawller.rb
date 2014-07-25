require_relative "../lib/tweets_downloader.rb"

td = MiniTwitter::TweetsDownloader.new(unmarshal_social_network: true, serialize_on_rate_limit: true, latest_version: true )
td.crawl( td.sn.users_to_crawl, infinity: true )
