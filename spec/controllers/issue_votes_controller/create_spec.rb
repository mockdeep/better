require 'spec_helper'

describe IssueVotesController, '#create' do
  context 'when issue vote saves' do
    it 'flashes a success message' do
      user = Factory.create(:user)
      issue = Factory.create(:issue)
      params = { :user_id => user.id, :issue_id => issue.id, :points => 5, :vote_type => 2 }

      post(:create, :issue_vote => params)

      flash[:success].should == 'IssueVote was successfully created.'
    end

    it 'redirects to the show page' do
      user = Factory.create(:user)
      issue = Factory.create(:issue)
      params = { :user_id => user.id, :issue_id => issue.id, :points => 5, :vote_type => 2 }

      post(:create, :issue_vote => params)

      response.should redirect_to(IssueVote.last)
    end

    it 'renders the issue vote as xml when format is xml' do
      user = Factory.create(:user)
      issue = Factory.create(:issue)
      params = { :user_id => user.id, :issue_id => issue.id, :points => 5, :vote_type => 2 }

      post(:create, :issue_vote => params, :format => 'xml')

      response.body.should == IssueVote.last.to_xml
    end
  end

  context 'when issue vote does not save' do
    it 'renders the new action' do
      user = Factory.create(:user)
      issue = Factory.create(:issue)
      params = { :user_id => user.id, :issue_id => issue.id }

      post(:create, :issue_vote => params)

      response.body.should include('New issue_vote')
    end

    it 'renders the issue errors as xml when format is xml' do
      user = Factory.create(:user)
      issue = Factory.create(:issue)
      params = { :user_id => user.id, :issue_id => issue.id }

      post(:create, :issue_vote => params, :format => 'xml')

      issue_vote = IssueVote.new(params)
      issue_vote.should_not be_valid
      response.body.should == issue_vote.errors.to_xml
    end
  end
end
