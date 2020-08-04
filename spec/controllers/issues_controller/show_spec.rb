require 'spec_helper'

describe IssuesController, '#show' do
  it 'sets @journals' do
    issue = Factory.create(:issue)
    journal = Factory.create(:journal, :journalized => issue)

    get(:show, :id => issue.id)

    assigns(:journals).should == [journal]
  end

  it 'sets indices on journals' do
    issue = Factory.create(:issue)
    Factory.create(:journal, :journalized => issue)
    Factory.create(:journal, :journalized => issue)

    get(:show, :id => issue.id)

    assigns(:journals).map(&:indice).should == [1, 2]
  end

  it 'reverses journals when user wants comments in reverse order' do
    user = Factory.create(:user)
    login_as(user)
    Factory.create(:user_preference, :user => user, :comments_sorting => 'desc')
    issue = Factory.create(:issue)
    journal_1 = Factory.create(:journal, :journalized => issue)
    journal_2 = Factory.create(:journal, :journalized => issue)

    get(:show, :id => issue.id)

    journals = assigns(:journals)
    journals.should == [journal_2, journal_1]
    journals.map(&:indice).should == [2, 1]
  end
end
