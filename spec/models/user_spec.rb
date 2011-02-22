require 'spec_helper'

describe User do
  describe "Mailchimp integration" do
    it "should have ENV keys" do
      ENV['MAILCHIMP_KEY'].should_not be_nil
      ENV['MAILCHIMP_ML'].should_not be_nil
    end
=begin
    it "should subscribe to list" do
      @h = mock("Hominid::API", [:find_list_by_name])
      Hominid::API.stub!(:new).and_return(@h)
      
      @user = Factory.create(:user)
      @l = mock("Hominid::List")
      @h.stub(:find_list_by_name).and_return(@l)
      @l.should_receive(:list_subscribe).and_return(true)
      
      User.add_to_mailing_list(@user.id)
    end
=end
  end
end