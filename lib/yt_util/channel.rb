module YtUtil
  module Channel
    module URL
      def self.play_all(username)
        result = YtUtil::URL.request("https://www.youtube.com/user/#{username}")
        result = try { result.css('a.play-all-icon-btn').first.attributes["href"].value }
        result ? "https://www.youtube.com".concat(result) : nil
      end
    end
  end
end