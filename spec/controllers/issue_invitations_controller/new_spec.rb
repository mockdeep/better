require 'spec_helper'

describe IssueInvitationsController, '#new' do
  it 'renders a new quote as xml when format is xml' do
    get(:new, :format => 'xml')

    response.body.should == Quote.new.to_xml
  end
end
