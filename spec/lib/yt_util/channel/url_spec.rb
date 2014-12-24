describe YtUtil::Channel::URL, "#play_all" do

  context "with pewdiepie username" do
    before{ @req = YtUtil::Channel::URL.play_all('pewdiepie') }
    subject { @req }
    it { expect(@req).to eq("https://www.youtube.com/watch?v=iZSB-UfrmPs&list=UU-lHJZR3Gqxm24_Vd_AJ5Yw") }
  end

  context "with user without feature" do
    before{ @req = YtUtil::Channel::URL.play_all('dockerrun') }
    subject { @req }
    it { expect(@req).to be_nil }
  end
end