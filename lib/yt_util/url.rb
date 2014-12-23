module YtUtil
  module URL
    # https://developers.google.com/youtube/player_parameters
    # Recommended included options for embedded video
    # {:embed => true, :autoplay => true, :origin => request.env["REQUEST_URI"]}
    def self.generate(video_code, options = {})
      raise "Invalid object type" unless video_code.is_a? String
      raise "Invalid video code" unless video_code.length == 11
      options.default = false
      parameters = "?"
      parameters.define_singleton_method(:ingest) {|item| self.<<("&") unless self[-1]["?"]; self.replace self.<<(item) }

      parameters.ingest("autoplay=1") if options[:autoplay]
      if options[:showplay]
        parameters.ingest("autohide=2")
      elsif options[:autohide]
        parameters.ingest("autohide=1")
      elsif options[:nohide]
        parameters.ingest("autohide=0")
      end
      parameters.ingest("cc_load_policy=1") if options[:cc]
      parameters.ingest("color=white") if options[:color] and !options[:modestbranding]
      parameters.ingest("controls=0") if options[:nocontrols]
      parameters.ingest("disablekb=1") if options[:nokeyboard]
      parameters.ingest("enablejsapi=1") if options[:jsapi]
      parameters.ingest("end=#{options[:end]}") if options[:end]
      parameters.ingest("fs=0") if options[:nofullscreen]
      # hl
      parameters.ingest("iv_load_policy=3") if options[:noanotate]
      # list
      # listType
      parameters.ingest("loop=1") if options[:loop]
      parameters.ingest("modestbranding=1") if options[:noytlogo]
      parameters.ingest("origin=http://#{URI.parse(options[:origin]).host}") if options[:origin]
      # playerapiid
      # playlist
      parameters.ingest("playsinline=1") if options[:playinline]
      parameters.ingest("rel=0") if options[:norelated]
      parameters.ingest("showinfo=0") if options[:hideinfo]
      parameters.ingest("start=#{options[:start]}") if options[:start]
      parameters.ingest("theme=light") if options[:lighttheme]

      parameters=("") if parameters.length.==(1)

      if options[:short]
        "http://youtu.be/#{video_code}".<<(parameters)
      elsif options[:embed]
        "//www.youtube.com/embed/#{video_code}".<<(parameters)
      else
        "https://www.youtube.com/watch?v=#{video_code}".<<(parameters.gsub("?","&"))
      end
    end

    def self.request(web_request)
      try { Mechanize.new.tap { |i| i.follow_meta_refresh = true }.get(web_request).parser } ||
        Nokogiri::HTML(open(web_request))
    end
  end
end