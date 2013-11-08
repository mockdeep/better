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
    before :each do
      credit.amount = 5
      credit.save
      Share.stub(:set_expiration)
    end

    context 'if payout amount is greater than credit amount' do
      it 'returns false' do
        credit.pay_out(7).should be_false
      end
    end

    context 'if payout amount is less than credit amount' do
      it 'creates new credit equal to the remaining balance' do
        expect {
          credit.pay_out(3)
        }.to change(Credit, :count).by(1)
      end
    end
  end

  describe '.round' do
    it 'rounds Credit amount to ROUNDING_LEVEL decimal places' do
      amount = 1.2345
      ROUNDING_LEVEL = 2
      Credit.round(amount).should == 1.23
    end
  end

  describe '.settle' do
    let(:project) { Factory.create(:project) }
    let!(:credit) { Credit.create!(:project => project, :enabled => true, :amount => 10) }

    before :each do
      Share.stub(:set_expiration)
    end

    context 'remaining amount exceeds day amount' do
      it 'pays out full credit amount' do
        Credit.settle(project, 20)
        credit.reload.amount.should == 10
      end
    end

    context 'remaining amount is a fraction of day amount' do
      it 'pays out fractional credit amount' do
        Credit.settle(project, 5)
        credit.reload.amount.should == 5
      end
    end
  end

  describe '.transfer' do
    let(:project) { Factory.create(:project) }
    let!(:credit) { Credit.create!(:project => project, :owner => sender, :amount => 10)}
    let(:sender) { Factory.create(:user) }
    let(:recipient) { Factory.create(:user) }

    before :each do
      Notification.stub(:create)
    end

    context 'when sender credit balance exceeds transfer amount' do
      before :each do
        Credit.transfer(sender, recipient, project, 3, "enjoy")
      end

      it 'transfers the full transfer amount to the recipient' do
        recipient.credits.first.amount.should == 3
      end

      it 'computes remaining credit balance' do
        credit.reload.amount.should == 7
      end
    end

    context 'the sender credit blance is less than the transfer amount' do
      it 'transfers all sender credit balance to recipient' do
        Credit.transfer(sender, recipient, project, 20, "you are rich")
        credit.reload.owner.should == recipient
        credit.amount.should == 10
      end
    end
  end

end
