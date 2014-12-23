module YtUtil
  module Scrape

    # Google search tips
    # OR range etc https://support.google.com/websearch/answer/136861?hl=en
    # punctuation: https://support.google.com/websearch/answer/2466433

    def self.query(search, filters = "") # Returns an Array of Hash results
      results = Mechanize.new.
        tap { |i| i.follow_meta_refresh = true }.
        get("https://www.youtube.com/results?search_query=#{Addressable::URI.parse(search).normalize + filters}")
      parse_query(results.parser)
    end

    def self.video_statistics(video_code) # Video page hit.
      result = Nokogiri::HTML(open("https://www.youtube.com/watch?v=#{video_code}"))
      parse_video_page(result)
    end

    def self.user_statistics(username)
      results = Mechanize.new.
        tap { |i| i.follow_meta_refresh = true }.
        get("https://www.youtube.com/user/#{username}/about")
      parse_user(results.parser)
    end

    private
    def self.parse_query(query_result)
      query_result.css("ol.item-section > li")[1..-1].map do |result|
        {
          title: result.css("div:nth-child(1)").css("div:nth-child(2)").css("h3").text,
          video: result.css("div:nth-child(1)").css("div:nth-child(2)").css("h3 > a").first[:href].dup.tap{|i|i.replace i[(i.index("=").to_i+1)..-1]},
          views: Integer(String(/(\d+)/.match(result.css("div:nth-child(1)").css("div:nth-child(2)").css("li:nth-child(3)").text.gsub(",", "")))),
          new: !!result.css("div:nth-child(1)").css("div:nth-child(2)").css("div:nth-child(4)").css("ul:nth-child(1)").text["New"],
          hd: !!result.css("div:nth-child(1)").css("div:nth-child(2)").css("div:nth-child(4)").css("ul:nth-child(1)").text["HD"],
          description: result.css("div:nth-child(1)").css("div:nth-child(2)").css("div:nth-child(3)").text,
          length: result.css("div:nth-child(1)").css("div:nth-child(1)").css("a:nth-child(1)").css("span:nth-child(2)").text
        }
      end
    end

    def self.parse_video_page(query_result)
      {
        video: video_code,
        user_name: query_result.css('a.yt-user-name').text,
        description: query_result.css('p#eow-description').text,
        category: query_result.css('li.watch-meta-item:nth-child(1)').css('ul:nth-child(2)').css('li:nth-child(1)').css('a:nth-child(1)').first[:href].try(:[], 1..-1),
        # Views are rounded to nearest thousand.
        views: String(/(\d+)/.match(query_result.css('div.watch-view-count').text.strip.gsub(',', ''))).to_i*1000,
        # Likes are rounded to nearest thousand.
        likes: String(/(\d+)/.match(query_result.css('button#watch-like').text.strip.gsub(',', ''))).to_i*1000,
        # Dislikes are rounded to nearest thousand.
        dislikes: String(/(\d+)/.match(query_result.css('button#watch-dislike').text.strip.gsub(',', ''))).to_i*1000,
        published: query_result.css('strong.watch-time-text').text[13..-1],
        license: query_result.css('li.watch-meta-item:nth-child(2)').text.gsub("\n", '').strip.tap {|i| i.replace i[i.index(' ').to_i..-1].strip}
      }
    end

    def self.parse_user(query_result)
      views_n_subs = query_result.css('.about-stats').
        css('li').take(2).map{|i| i = i.text.strip; {
        i.match(/[a-z]+/)[0] => i.match(/[\d,]+/)[0]}
      }.inject(:update)

      {
        description: query_result.css('.about-description').css('p').text,
        link: query_result.css('a[title="Google+"]')[0]["href"],
        views: views_n_subs["views"],
        subscribers: views_n_subs["subscribers"],
        joined: query_result.css('.about-stats').css('.joined-date').text.strip
      }
    end

  end
end