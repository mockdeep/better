require 'spec_helper'

describe IssueRelationsController, '#new' do

  it 'sets @relation' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_as_core(issue.project)
    login_as(user)

    get(:new, :issue_id => issue.id, :relation => { :delay => 52 })

    assigns(:relation).delay.should == 52
  end

  it 'sets issue_from on the relation' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_as_core(issue.project)
    login_as(user)

    get(:new, :issue_id => issue.id, :relation => { :delay => 52 })

    assigns(:relation).issue_from.should == issue
  end

  context 'when issue_to_id is given' do
    it 'sets issue_to on the relation when issue is visible' do
      user = Factory.create(:user)
      issue_1 = Factory.create(:issue)
      issue_2 = Factory.create(:issue)
      user.add_as_core(issue_1.project)
      login_as(user)

      get(:new, :issue_id => issue_1.id, :relation => { :issue_to_id => issue_2.id })

      assigns(:relation).issue_to.should == issue_2
    end

    it 'leaves issue_to blank on the relation when issue is not visible' do
      user = Factory.create(:user)
      issue_1 = Factory.create(:issue)
      user.add_as_core(issue_1.project)
      project_2 = Factory.create(:project, :is_public => false)
      issue_2 = Factory.create(:issue, :project => project_2)
      login_as(user)

      get(:new, :issue_id => issue_1.id, :relation => { :issue_to_id => issue_2.id })

      assigns(:relation).issue_to.should be_nil
    end
  end

end
