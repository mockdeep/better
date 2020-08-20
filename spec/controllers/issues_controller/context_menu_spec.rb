require 'spec_helper'

describe IssuesController, '#context_menu' do

  it 'assigns @issues for all given ids' do
    issue_1 = Factory.create(:issue)
    issue_2 = Factory.create(:issue)
    Factory.create(:issue)

    get(:context_menu, :ids => [issue_1.id, issue_2.id])

    assigns(:issues).should == [issue_1, issue_2]
  end

  context 'when only one issue is found' do
    it 'assigns @issue' do
      issue_1 = Factory.create(:issue)

      get(:context_menu, :ids => [issue_1.id])

      assigns(:issue).should == issue_1
    end

    it 'sets @allowed_statuses' do
      issue = Factory.create(:issue)
      user = Factory.create(:user)
      Factory.create(
        :workflow,
        :new_status => issue.status,
        :old_status => issue.status,
        :tracker => issue.tracker,
        :role => Role.core_member
      )
      user.add_as_core(issue.project)
      login_as(user)

      get(:context_menu, :ids => [issue.id])

      assigns(:allowed_statuses).should == [issue.status]
    end
  end

  it 'sets @can to nil values when more than one project' do
    issue_1 = Factory.create(:issue)
    issue_2 = Factory.create(:issue)

    get(:context_menu, :ids => [issue_1, issue_2])

    assigns(:can).should == {
      :edit => nil,
      :update => nil,
      :move => nil,
      :copy => nil,
      :delete => nil,
    }
  end

  context 'when only one project is found' do
    it 'sets @project' do
      issue_1 = Factory.create(:issue)
      issue_2 = Factory.create(:issue, :project => issue_1.project)

      get(:context_menu, :ids => [issue_1, issue_2])

      assigns(:project).should == issue_1.project
    end

    it 'sets @can values to true when user can manage project' do
      issue = Factory.create(:issue)
      user = Factory.create(:user)
      user.add_to_project(issue.project, Role.administrator)
      login_as(user)

      get(:context_menu, :ids => [issue.id])

      assigns(:can).should == {
        :edit => true,
        :update => true,
        :move => true,
        :copy => true,
        :delete => true,
      }
    end

    it 'sets @can values to false when user cannot manage project' do
      issue = Factory.create(:issue)

      get(:context_menu, :ids => [issue.id])

      assigns(:can).should == {
        :edit => false,
        :update => false,
        :move => false,
        :copy => false,
        :delete => false,
      }
    end

    it 'assigns @assignables' do
      user = Factory.create(:user)
      issue = Factory.create(:issue)
      user.add_to_project(issue.project, Role.member)

      get(:context_menu, :ids => [issue.id])

      assigns(:assignables).should == [user]
    end

    it 'adds the assigned_to user to @assignables' do
      user = Factory.create(:user)
      issue = Factory.create(:issue, :assigned_to => user)

      get(:context_menu, :ids => [issue.id])

      assigns(:assignables).should == [user]
    end
  end
end
