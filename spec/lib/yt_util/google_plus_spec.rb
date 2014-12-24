describe YtUtil::GooglePlus, "#get_username" do

  context "with docker username" do
    before{ @req = YtUtil::GooglePlus.get_username('dockerrun') }
    subject { @req }
    it { expect(@req).to eq("+DockerIo") }
  end

  context "with invalid input" do
    specify { expect(YtUtil::GooglePlus.get_username('')).to be_nil }
    specify { expect { YtUtil::GooglePlus.get_username('!@#$%^&*(~!@#$%') }.to raise_error(Mechanize::ResponseCodeError, /404/) }
  end
end