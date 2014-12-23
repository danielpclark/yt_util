module YtUtil
  module Scrape

    # Google search tips
    # OR range etc https://support.google.com/websearch/answer/136861?hl=en
    # punctuation: https://support.google.com/websearch/answer/2466433

    def self.raw_query(search, filters = "")
      raise "Invalid object type" unless search.is_a? String and filters.is_a? String
      request_query(search,filters)
    end

    def self.query(search = nil, filters = "", &qry)
      result = qry.try(:call) || raw_query(search,filters)
      parse_query(result)
    end

    def self.raw_video_stats(video_code)
      raise "Invalid object type" unless video_code.is_a? String
      raise "Invalid video code" unless video_code.length == 11
      request_video_stats(video_code)
    end

    def self.video_stats(video_code = nil, &qry)
      result = qry.try(:call) || raw_video_stats(video_code)
      parse_video_page(video_code, result)
    end

    def self.raw_user_stats(username)
      raise "Invalid object type" unless username.is_a? String

    end

    def self.user_stats(username = nil, &qry)
      result = qry.try(:call) || raw_user_stats(username)
      parse_user(result)
    end

    private
    def self.request(web_request)
      try { Mechanize.new.tap { |i| i.follow_meta_refresh = true }.get(web_request).parser } ||
        Nokogiri::HTML(open(web_request))
    end

    def self.request_query(search, filters = "")
      web_request = "https://www.youtube.com/results?search_query=#{Addressable::URI.parse(search).normalize + filters}"
      request(web_request)
    end

    def self.request_video_stats(video_code)
      web_request = "https://www.youtube.com/watch?v=#{video_code}"
      request(web_request)
    end

    def self.request_user_stats(username)
      web_request = "https://www.youtube.com/user/#{username}/about"
      request(web_request)
    end

    def self.parse_query(query_result)
      query_result.css("ol.item-section > li")[1..-1].map do |result|
        {
          title: try {result.css("div:nth-child(1)").css("div:nth-child(2)").css("h3").text},
          video: try {result.css("div:nth-child(1)").css("div:nth-child(2)").css("h3 > a").first[:href].dup.tap{|i|i.replace i[(i.index("=").to_i+1)..-1]}},
          views: try {result.css('li').select {|i| i.text =~ /^[\d,]{1,} views/ }.first.text.split.first.gsub(",","_").to_i},
          new: try {!!result.css("div:nth-child(1)").css("div:nth-child(2)").css("div:nth-child(4)").css("ul:nth-child(1)").text["New"]},
          hd: try {!!result.css("div:nth-child(1)").css("div:nth-child(2)").css("div:nth-child(4)").css("ul:nth-child(1)").text["HD"]},
          description: try {result.css("div:nth-child(1)").css("div:nth-child(2)").css(".yt-lockup-description").text},
          length: try {result.css("div:nth-child(1)").css("div:nth-child(1)").css("a:nth-child(1)").css("span:nth-child(2)").text}
        }
      end
    end

    def self.parse_video_page(video_code, query_result)
      {
        video: video_code || try {query_result.css('meta').select {|i| i.attributes["property"].try(:value) =~ /og:url/}.first["content"].match(/\?v=(.+)/)[1]},
        user_name: try {query_result.css('li').css('a').select{|i| i.text =~ / by [a-z0-9]{1,}/i}.map {|i| i.text.match(/by ([a-z0-9]{1,})/i)[1]}.first},
        description: try {query_result.css('p#eow-description').text},
        category: try {query_result.css('.watch-meta-item').css('a').text},
        views: try {String(/(\d+)/.match(query_result.css('div.watch-view-count').text.strip.gsub(',', ''))).to_i},
        likes: try {String(/(\d+)/.match(query_result.css('button#watch-like').text.strip.gsub(',', ''))).to_i},
        dislikes: try {String(/(\d+)/.match(query_result.css('button#watch-dislike').text.strip.gsub(',', ''))).to_i},
        published: try {query_result.css('strong.watch-time-text').text.match(/ on ([a-z0-9, ]{11,})/i)[1]},
        license: try {query_result.css('li.watch-meta-item:nth-child(2)').text.gsub("\n", '').strip.tap {|i| i.replace i[i.index(' ').to_i..-1].strip}}
      }
    end

    def self.parse_user(query_result)
      views_n_subs = try {query_result.css('.about-stats').
        css('li').take(2).map{|i| i = i.text.strip; {
        i.match(/[a-z]+/)[0] => i.match(/[\d,]+/)[0]}
      }.inject(:update)}

      {
        description: try {query_result.css('.about-description').css('p').text},
        link: try {query_result.css('a[title="Google+"]')[0]["href"]},
        views: try {views_n_subs["views"]},
        subscribers: try {views_n_subs["subscribers"]},
        joined: try {query_result.css('.about-stats').css('.joined-date').text.strip}
      }
    end

  end
end