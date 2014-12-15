require 'spec_helper'

describe MotionVote, '.belong_to_user' do

  let(:user) { Factory.create(:user) }
  let(:motion_vote) { Factory.create(:motion_vote, :user => user) }

  it 'returns motion vote that belongs to the user' do
    MotionVote.belong_to_user(user.id).should == [motion_vote]
  end

end
