describe YtUtil::URL, "#generate" do

  context "with no parameters" do
    before{ @req = YtUtil::URL.generate('12345678901') }
    subject { @req }
    it { expect(@req).to eq("https://www.youtube.com/watch?v=12345678901") }
  end

  context "with embed parameter" do
    before{ @req = YtUtil::URL.generate('12345678901', {embed: true}) }
    subject { @req }
    it { expect(@req).to eq("//www.youtube.com/embed/12345678901") }
  end

  context "with :short url parameter" do
    before{ @req = YtUtil::URL.generate('12345678901', {short: true}) }
    subject { @req }
    it { expect(@req).to eq("http://youtu.be/12345678901") }
  end
end

describe YtUtil::URL, "#request" do

  context "with a valid url" do
    before{ @req = YtUtil::URL.request('https://www.google.com') }
    subject { @req }
    it { expect(@req).to respond_to :css }
  end

  context "with an invalid url" do
    specify { expect {YtUtil::URL.request('')}.to raise_error(ArgumentError) }
  end
end