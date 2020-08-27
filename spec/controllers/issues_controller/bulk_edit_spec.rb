require 'spec_helper'

describe IssuesController, '#bulk_edit' do
  it 'raises an error when request is GET' do
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    login_as(user)

    expect { get(:bulk_edit, :id => issue.id) }.
      to raise_error(ActionView::MissingTemplate)
  end

  it 'sets the tracker when tracker_id is given' do
    tracker = Factory.create(:tracker)
    user = Factory.create(:user)
    issue = Factory.create(:issue)
    login_as(user)

    post(:bulk_edit, :id => issue.id, :tracker_id => tracker.id)

    issue.reload.tracker.should == tracker
  end

  it 'does not set tracker when invalid tracker_id is given' do
    tracker_1 = Factory.create(:tracker)
    issue = Factory.create(:issue, :tracker => tracker_1)
    tracker_2 = Factory.create(:tracker)
    user = Factory.create(:user)
    login_as(user)

    post(:bulk_edit, :id => issue.id, :tracker_id => tracker_2.id)

    issue.reload.tracker.should == tracker_1
  end

  it 'does not set tracker to nil when no tracker_id is given' do
    tracker = Factory.create(:tracker)
    issue = Factory.create(:issue, :tracker => tracker)
    user = Factory.create(:user)
    login_as(user)

    post(:bulk_edit, :id => issue.id)

    issue.reload.tracker.should == tracker
  end

  it 'sets the status on the issue when status_id is given' do
    status = Factory.create(:issue_status)
    issue = Factory.create(:issue)
    user = Factory.create(:user)
    Factory.create(:workflow, :tracker => issue.tracker, :role => Role.non_member, :old_status => issue.status, :new_status => status)
    login_as(user)

    post(:bulk_edit, :id => issue.id, :status_id => status.id)

    issue.reload.status.should == status
  end
end
