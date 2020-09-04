require 'spec_helper'

describe TrackersController, '#new' do
  it 'renders the new view' do
    login_as(Factory.create(:user, :admin => true))

    get(:new)

    response.body.should include('New type')
  end

  context 'when request is POST' do
    it 'renders the new view when params are invalid' do
      login_as(Factory.create(:user, :admin => true))

      post(:new)

      response.body.should include('New type')
    end

    it 'creates a new tracker when params are valid' do
      login_as(Factory.create(:user, :admin => true))

      expect { post(:new, :tracker => { :name => 'blah' }) }.
        to change(Tracker, :count).by(1)

      Tracker.last.name.should == 'blah'
    end

    it 'copies workflows when param is given' do
      login_as(Factory.create(:user, :admin => true))
      workflow = Factory.create(:workflow)

      post(:new, :tracker => { :name => 'blah' }, :copy_workflow_from => workflow.tracker_id)

      tracker = Tracker.last
      tracker.workflows.length.should == 1
      new_workflow = tracker.workflows.first
      new_workflow.should_not == workflow
      new_workflow.role.should == workflow.role
      new_workflow.old_status.should == workflow.old_status
      new_workflow.new_status.should == workflow.new_status
    end

    it 'does not copy workflows when copy from tracker is not found' do
      login_as(Factory.create(:user, :admin => true))

      post(:new, :tracker => { :name => 'blah' }, :copy_workflow_from => -1)

      Tracker.last.workflows.should == []
    end

    it 'does not copy workflows when copy from param is blank' do
      login_as(Factory.create(:user, :admin => true))

      post(:new, :tracker => { :name => 'blah' }, :copy_workflow_from => "\n \t")

      Tracker.last.workflows.should == []
    end

    it 'flashes a success message' do
      login_as(Factory.create(:user, :admin => true))

      post(:new, :tracker => { :name => 'blah' })

      flash[:success].should == I18n.t(:notice_successful_create)
    end

    it 'redirects to the list page' do
      login_as(Factory.create(:user, :admin => true))

      post(:new, :tracker => { :name => 'blah' })

      response.should redirect_to(:action => 'list')
    end
  end
end
