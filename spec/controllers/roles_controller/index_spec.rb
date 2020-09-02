require 'spec_helper'

describe RolesController, '#index' do
  it 'renders the list action without layout when request is ajax' do
    user = Factory.create(:user, :admin => true)
    login_as(user)

    xhr(:get, :index)

    response.body.should include('Core Team')
    response.body.should include('Clearance')
    response.body.should_not include('html')
  end

  it 'renders the list action with layout when request is not ajax' do
    user = Factory.create(:user, :admin => true)
    login_as(user)

    get(:index)

    response.body.should include('Core Team')
    response.body.should include('Clearance')
    response.body.should include('html')
  end

end
