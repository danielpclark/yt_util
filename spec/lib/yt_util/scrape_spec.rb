describe YtUtil::Scrape, "#query" do

  context "with doctor who" do
    before{ @req = YtUtil::Scrape.query('doctor who').first }
    subject { @req }
    it { expect(@req).to be_kind_of Hash }
    it { expect(@req[:title]).to be_kind_of String }
    it { expect(@req[:video]).to be_kind_of String }
    it { expect(@req[:views]).to be_kind_of Integer }
    it { expect(@req[:new]).to satisfy {|v| v == true or v == false} }
    it { expect(@req[:hd]).to satisfy {|v| v == true or v == false} }
    it { expect(@req[:description]).to be_kind_of String }
    it { expect(@req[:length]).to be_kind_of String }
  end
end

describe YtUtil::Scrape, "#video_stats" do
  context "with duck song" do
    before{ @req = YtUtil::Scrape.video_stats('MtN1YnoL46Q') }
    subject { @req }
    it { expect(@req).to be_kind_of Hash }
    it { expect(@req[:video]).to be_kind_of String }
    it { expect(@req[:video].length).to eq(11) }
    it { expect(@req[:user_name]).to be_kind_of String }
    it { expect(@req[:description]).to be_kind_of String }
    it { expect(@req[:category]).to be_kind_of String }
    it { expect(@req[:views]).to be_kind_of Integer }
    it { expect(@req[:likes]).to be_kind_of Integer }
    it { expect(@req[:dislikes]).to be_kind_of Integer }
    it { expect(@req[:published]).to be_kind_of String }
    it { expect(@req[:license]).to be_kind_of String }
  end
end

describe YtUtil::Scrape, "#user_stats" do
  context "with docker username" do
    before{ @req = YtUtil::Scrape.user_stats('dockerrun') }
    subject { @req }
    it { expect(@req).to be_kind_of Hash }
    it { expect(@req[:image]).to be_kind_of String }
    it { expect(@req[:description]).to be_kind_of String }
    it { expect(@req[:link]).to be_kind_of String }
    it { expect(@req[:views]).to be_kind_of Integer }
    it { expect(@req[:subscribers]).to be_kind_of Integer }
    it { expect(@req[:joined]).to be_kind_of String }
  end
end