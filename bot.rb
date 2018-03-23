require 'cinch'
require 'open-uri'
require 'nokogiri'
require 'cgi'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "chat.freenode.net"
    c.nick = "ImNotABotTrustMe"
    c.channels = ["#mirrorconf-test"]
  end

  on :join do |m|
    unless m.user.nick == bot.nick # We shouldn't attempt to message  ourselves
      m.reply "Hello, #{m.user.nick}! You are lucky because Im native from Braga and know everything about it! Do you have any question? Please, ask me!"
    end
  end

  helpers do
    # Extremely basic method, grabs the first result returned by Google
    # or "No results found" otherwise
    def google(query)
puts "google function"
      url = "http://www.google.com/search?q=#{CGI.escape(query)}+braga+portugal"
      res = Nokogiri.parse(open(url).read).at("h3.r")
      title = res.text
      link = res.at('a')[:href]
      desc = res.at("./following::div").children.first.text
    rescue
      "Sorry, I dont understand. But anyway, you can buy early bird tickets to MirrorConf here: https://ti.to/subvisual/mirror-conf-2018/with/krxd0s3-khw"
    else
      CGI.unescape_html "Ah! You caught me! I dont know that but this might help you: #{title}  #{desc}  -  #{link}"
    end
  end

  on :message, /(.+)/ do |m, query|
    m.reply google(query)
  end
end

bot.start
