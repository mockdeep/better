require 'spec_helper'

describe IssueInvitationsController, '#create' do
  it 'assigns @quote' do
    post(:create, :quote => { :author => 'me', :body => 'welp' })

    quote = assigns(:quote)
    quote.author.should == 'me'
    quote.body.should == 'welp'
  end

  it 'sets the user on the quote' do
    post(:create)

    assigns(:quote).user_id.should == User.anonymous.id
  end

  it 'flashes a success message' do
    flash.stub(:sweep)

    post(:create)

    flash.now[:success].should == 'Invitation was successfully created and sent'
  end

  it 'redirects to the quote' do
    post(:create)

    response.should redirect_to(quotes_path)
  end

  it 'renders the quote as xml when format is xml' do
    quote_params = { :author => 'you', :body => 'yep' }

    post(:create, :quote => quote_params, :format => 'xml')

    test_quote = Quote.new(quote_params.merge(:user_id => User.anonymous.id))
    response.body.should == test_quote.to_xml
    response.status.should == "201 Created"
    response.location.should == quotes_url
  end
end
