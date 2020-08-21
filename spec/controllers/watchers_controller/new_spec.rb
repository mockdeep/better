require 'spec_helper'

describe WatchersController, '#new' do
  it 'assigns @watcher' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_to_project(issue.project, Role.core_member)
    login_as(user)

    get(:new, :object_type => 'issue', :object_id => issue.id)

    assigns(:watcher).should be_new_record
  end

  it 'assigns @watchable on @watcher' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_to_project(issue.project, Role.core_member)
    login_as(user)

    get(:new, :object_type => 'issue', :object_id => issue.id)

    assigns(:watcher).watchable.should == issue
  end

  it 'saves the watcher when request is POST' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_to_project(issue.project, Role.core_member)
    login_as(user)

    post(
      :new,
      :object_type => 'issue',
      :object_id => issue.id,
      :watcher => { :user_id => user.id }
    )

    assigns(:watcher).should_not be_new_record
    assigns(:watcher).user.should == user
  end

  it 'redirects back when format is html' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_to_project(issue.project, Role.core_member)
    login_as(user)
    request.env['HTTP_REFERER'] = '/boo'

    get(:new, :object_type => 'issue', :object_id => issue.id)

    response.should redirect_to('/boo')
  end

  it 'renders the update page when format is js' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_to_project(issue.project, Role.core_member)
    login_as(user)

    get(:new, :object_type => 'issue', :object_id => issue.id, :format => 'js')

    response.body.should include('Watchers')
  end

  it 'renders text when no referer' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    user.add_to_project(issue.project, Role.core_member)
    login_as(user)

    get(:new, :object_type => 'issue', :object_id => issue.id)

    response.status.should == '200 OK'
    response.body.should include('Watcher added.')
  end
end
