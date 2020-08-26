require 'spec_helper'

describe JournalsController, '#edit' do
  it 'renders the edit template when request is GET' do
    user = Factory.create(:user)
    journal = Factory.create(:journal, :user => user)
    login_as(user)

    get(:edit, :id => journal.id)

    response.status.should == '200 OK'
    response.body.should include("journal-#{journal.id}-notes")
  end

  it 'updates the journal notes when present' do
    user = Factory.create(:user)
    journal = Factory.create(:journal, :user => user)
    login_as(user)

    post(:edit, :id => journal.id, :notes => 'yep')

    journal.reload.notes.should == 'yep'
  end

  it 'destroys the journal when no details or notes' do
    user = Factory.create(:user)
    journal = Factory.create(:journal, :user => user)
    login_as(user)

    post(:edit, :id => journal.id)

    Journal.find_by_id(journal.id).should be_nil
  end

  it 'updates activity streams when notes are present' do
    user = Factory.create(:user)
    journal = Factory.create(:journal, :user => user)
    activity_stream = Factory.create(:activity_stream, :indirect_object => journal, :object_type => 'Issue', :actor => user)
    login_as(user)

    post(:edit, :id => journal.id, :notes => 'goober')

    activity_stream.reload.indirect_object_description.should == 'goober'
  end

  it 'redirects to issues/show when format is HTML' do
    user = Factory.create(:user)
    journal = Factory.create(:journal, :user => user)
    activity_stream = Factory.create(:activity_stream, :indirect_object => journal, :object_type => 'Issue', :actor => user)
    login_as(user)

    post(:edit, :id => journal.id, :notes => 'goober')

    response.should redirect_to(:controller => 'issues', :action => 'show', :id => journal.journalized_id)
  end

  it 'renders the update js file when format is JS' do
    user = Factory.create(:user)
    journal = Factory.create(:journal, :user => user)
    activity_stream = Factory.create(:activity_stream, :indirect_object => journal, :object_type => 'Issue', :actor => user)
    login_as(user)

    post(:edit, :id => journal.id, :notes => 'goober', :format => 'js')

    response.body.should include("journal-#{journal.id}-notes")
  end

end
