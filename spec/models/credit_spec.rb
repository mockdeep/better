require "spec_helper"

describe Credit do

  let(:credit) { Credit.new(:amount => 100) }

  describe 'associations' do
    it { should belong_to(:owner) }
    it { should belong_to(:project) }
  end

  describe "#issue_day" do
    it "returns a string for date it was issued on" do
      time = Time.now
      credit.issued_on = time
      credit.issue_day.should == time.strftime('%D')
    end
  end

  describe "#disable" do
    it "sets enabled status to false" do
      credit.enabled = true
      credit.disable
      credit.enabled.should == false
    end

    it 'returns the result of the save' do
      credit.stub(:save).and_return(false)
      credit.disable.should be_false
    end
  end

  describe "#enable" do
    it "sets enabled status to true" do
      credit.enabled = false
      credit.enable
      credit.enabled.should == true
    end

    it 'returns the result of the save' do
      credit.stub(:save).and_return(true)
      credit.enable.should == true
    end
  end

  describe '#issue_shares' do
    context 'when not a previously_issued credit' do
      it 'creates new shares' do
        credit.stub(:previously_issued).and_return(false)
        expect {
          credit.issue_shares
        }.to change(Share, :count)
      end
    end
  end

  describe '#previously_issued' do
    context 'when issued_on and created_at differ more than 2 millisconds' do
      it 'returns true' do
        credit.issued_on = 10
        credit.created_at = 1
        credit.previously_issued.should be_true
      end
    end
  end

  describe '#settled?' do
    context 'when Credit is settled' do
      it 'returns false' do
      cr = Credit.new
      cr.should_receive(:settled)
      cr.settled?.should be_false
      end
    end
  end

  describe '#payout' do
  end

  describe '#self.round' do
    it 'rounds Credit amount to ROUNDING_LEVEL decimal places' do
      amount = 1.2345
      ROUNDING_LEVEL = 2
      Credit.round(amount).should == 1.23
    end
  end

  describe '#settle' do
  end

  describe '#transfer' do
  end

end
