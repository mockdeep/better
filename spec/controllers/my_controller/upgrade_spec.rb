require 'spec_helper'

describe MyController, '#upgrade' do
  it 'assigns @user' do
    user = Factory.create(:user)
    login_as(user)

    get(:upgrade)

    assigns(:user).should == user
  end

  it 'assigns @plans' do
    user = Factory.create(:user)
    login_as(user)

    get(:upgrade)

    assigns(:plans).length.should == 5
    assigns(:plans).should == Plan.all
  end

  it 'assigns @selected_plan' do
    user = Factory.create(:user)
    login_as(user)

    get(:upgrade)

    assigns(:selected_plan).should == Plan.find_by_name('Free')
  end

  context 'when request is POST' do
    it 'creates a Recurly::BillingInfo' do
      user = Factory.create(:user)
      plan = Plan.find_by_name("Go Nuts!")
      login_as(user)
      account_body = { :first_name => "Sarah", :last_name => "Boogerpants", :account_code => 'bloo' }.to_xml
      billing_body = { :bloo => 'blah' }.to_xml
      subscription_body = { :blargh => 'wat' }.to_xml
      FakeWeb.register_uri(:get, "https://app.recurly.com/accounts/#{user.id}.xml", :body => account_body)
      FakeWeb.register_uri(:put, "https://app.recurly.com/accounts/bloo/billing_info.xml", :body => billing_body)
      FakeWeb.register_uri(:get, "https://app.recurly.com/accounts/#{user.id}/subscription.xml", :body => subscription_body)

      post(:upgrade, :user => { :b_cc_last_four => 'blah', :plan_id => plan.id })

      response.should be_success
    end
  end
end
