require 'spec_helper'

describe TrackersController, '#index' do
  it 'renders the list view with no layout when request is xhr' do
    login_as(Factory.create(:user, :admin => true))

    xhr(:get, :index)

    response.body.should include('Types')
    response.body.should_not include('Administration')
  end

  it 'renders the list view with layout when request is not xhr' do
    login_as(Factory.create(:user, :admin => true))

    get(:index)

    response.body.should include('Types')
    response.body.should include('Administration')
  end
end
