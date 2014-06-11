require 'spec_helper'

describe Retro do

  describe 'associations' do
    it { should belong_to(:project) }

    it { should have_many(:issues) }
    it { should have_many(:journals).through(:issues) }
    it { should have_many(:issue_votes).through(:issues) }
    it { should have_many(:retro_ratings) }
    it { should have_many(:credit_distributions) }
  end

  describe "#ended?" do
    let(:retro) { Retro.new }

    context "when project status is ended" do
      it "returns true" do
        retro.status_id = Retro::STATUS_COMPLETE
        retro.ended?.should be true
      end
    end

    context "when project status is distributed" do
      it "returns true" do
        retro.status_id = Retro::STATUS_DISTRIBUTED
        retro.ended?.should be true
      end
    end

    context "when project status is in progress" do
      it "returns false" do
        retro.status_id = Retro::STATUS_INPROGRESS
        retro.ended?.should be false
      end
    end
  end
end
