# Mini Twitter

![IST Logo](http://tecnico.ulisboa.pt/img/tecnico.png)

Mini Twitter is a simple way to get a twitter crawler up and running without much of a fuss. Only the social network and tweets text is crawled, the objective is to quickly gather your own mini twitter where you can do whatever kind of text/social analysis that you are into. 

## How to use

Tweets Downloader is the class that lets you download new tweets:

~~~ruby
require_relative "../lib/tweets_downloader.rb"
@td = TweetsDownloader.new( ENV['THESIS_TWITTER_DEV_KEY'],
                               ENV['THESIS_TWITTER_DEV_SECRET'],
                               ENV['THESIS_TWITTER_DEV_ACCESS_TOKEN'],
                               ENV['THESIS_TWITTER_DEV_ACCESS_TOKEN_SECRET'])
 
~~~

Optionally you can load 4 already crawlled seeds @BarackObama, @tenderlove, @pitchfork and @EllenPage
~~~ruby
@td = TweetsDownloader.new( load_seeds: true )
@td.sn.user_exists? 'pitchfork' #=> true
~~~

Crawl an array of users safelly, if API limit is achieved wait 15 minutes and then resume crawling.
~~~ruby
@td.crawl( ['officialjaden', 14761655 ] ) 
~~~

For more examples and usage, check the bin or spec folder.

## License

This code is released under the [MIT License](http://www.opensource.org/licenses/MIT).
