require 'spec_helper'

describe QueriesController, '#edit' do
  it 'renders the edit template' do
    user = Factory.create(:user)
    query = Factory.create(:query, :user => user, :name => 'yabba')
    login_as(user)

    get(:edit, :id => query.id)

    response.body.should include('yabba')
  end
end
