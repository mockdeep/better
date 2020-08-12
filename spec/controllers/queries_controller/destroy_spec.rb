require 'spec_helper'

describe QueriesController, '#destroy' do
  it 'destroys the query when request is post' do
    user = Factory.create(:user)
    query = Factory.create(:query, :user => user)
    login_as(user)

    post(:destroy, :id => query.id)

    Query.find_by_id(query.id).should be_nil
  end

  it 'does not destroy the query when request is not post' do
    user = Factory.create(:user)
    query = Factory.create(:query, :user => user)
    login_as(user)

    get(:destroy, :id => query.id)

    Query.find_by_id(query.id).should == query
  end

  it 'redirects to the issues page for the project associated with the query' do
    user = Factory.create(:user)
    project = Factory.create(:project)
    query = Factory.create(:query, :user => user, :project => project)
    login_as(user)

    get(:destroy, :id => query.id)

    response.should redirect_to(:controller => 'issues', :action => 'index', :project_id => query.project_id, :set_filter => 1)
  end
end
