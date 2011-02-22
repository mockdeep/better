require 'spec_helper'

describe Project do
  describe "New project is created" do
    it "should set Retro Credit Threshold to a default" do
      p1 = Factory.create(:project)
      p1.retro_credit_threshold.should == 3000
    end
  end
  
  describe "occourence of retrospective" do
    it "should be ready if threshold is more than or equal to points" do
      p1 = Factory.create(:project)
      Factory.create(:issue, :points => 3000, :project_id => p1.id)
      p1.ready_for_retro.should be_true
    end
  end
end