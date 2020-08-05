require 'spec_helper'

describe IssuesController, '#new' do
  it 'sets a new @issue' do
    user = Factory.create(:user)
    project = Factory.create(:project)
    login_as(user)

    get(:new, :project_id => project.id)

    assigns(:issue).new_record?.should be true
  end

  context 'given copy_from' do
    it 'copies the new issue from existing when copy_from is given' do
      user = Factory.create(:user)
      project = Factory.create(:project)
      issue = Factory.create(:issue, :project => project, :subject => 'woo', :description => 'wah')
      login_as(user)

      get(:new, :project_id => project.id, :copy_from => issue.id)

      assigns(:issue).subject.should == 'woo'
      assigns(:issue).description.should == 'wah'
    end

    it 'ignores the tracker_id param when given' do
      user = Factory.create(:user)
      project = Factory.create(:project)
      issue = Factory.create(:issue, :project => project)
      tracker = Factory.create(:tracker)
      login_as(user)

      get(:new, :project_id => project.id, :copy_from => issue.id, :tracker_id => tracker.id)

      assigns(:issue).tracker.should_not == tracker
      assigns(:issue).tracker.should == issue.tracker
    end
  end

  it 'sets the project on the new issue' do
    user = Factory.create(:user)
    project = Factory.create(:project)
    login_as(user)

    get(:new, :project_id => project.id)

    assigns(:issue).project.should == project
  end

  it 'sets the tracker on the new issue given a tracker_id' do
    user = Factory.create(:user)
    project = Factory.create(:project)
    tracker = Factory.create(:tracker)
    login_as(user)

    get(:new, :project_id => project.id, :tracker_id => tracker.id)

    assigns(:issue).tracker.should == tracker
  end
end
