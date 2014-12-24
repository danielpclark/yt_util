# Youtube Utility
[![Gem Version](https://badge.fury.io/rb/yt_util.svg)](http://badge.fury.io/rb/yt_util)
[![Build Status](https://travis-ci.org/danielpclark/yt_util.svg)](https://travis-ci.org/danielpclark/yt_util)

General purpose toolbox for working with Youtube.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yt_util'
```

## Usage

Usage notes will come in time.  Feel free to look at the source code as it's rather short.

Methods available:
```ruby
YtUtil::Scrape.raw_query(search, filters = "")
YtUtil::Scrape.query(search = nil, filters = "", &qry)
YtUtil::Scrape.raw_video_stats(video_code)
YtUtil::Scrape.video_stats(video_code = nil, &qry)
YtUtil::Scrape.raw_user_stats(username)
YtUtil::Scrape.user_stats(username = nil, &qry)
YtUtil::URL.generate(video_code, options = {})
YtUtil::URL.request(web_request)
YtUtil::GooglePlus.get_username(youtube_username)
```

## NOTE
> Any scraping results may become unavailable at anytime if Youtube chooses to change their page layout.
This library is designed to return nil for any data it fails to scrape.

## Contribute

This project will become more and more complete over time.  Eventually the mapping of scraped data
will be implemented intelligently instead of statically.  This way when Youtube changes their site
the code will compensate for the change.  Feel free to contribute with this in mind.

## LICENSE

Copyright (c) 2014 Daniel P. Clark

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
