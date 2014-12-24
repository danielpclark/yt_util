module YtUtil
  module GooglePlus
    def self.get_username(youtube_username)
      return nil unless youtube_username.is_a? String
      return nil if youtube_username.empty?
      google_plus_link = YtUtil::Scrape.user_stats(youtube_username)[:link]
      return nil if google_plus_link.nil?
      google_plus_link = google_plus_link.match(/\?q=(.+)&/)[1] if google_plus_link =~ /\?.+&/
      result = YtUtil::URL.request(google_plus_link)
      result = result.css('a').map {|i|
        i["href"].match(/https:\/\/plus.google.com\/%2B(.+)\?/).try(:[],-1)
      }.compact.first
      result ? "+".concat(result.to_s) : nil
    end
  end
end