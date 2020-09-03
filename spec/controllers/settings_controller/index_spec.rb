require 'spec_helper'

describe SettingsController, '#index' do

  it 'renders the edit view' do
    user = Factory.create(:user, :admin => true)
    login_as(user)

    get(:index)

    response.status.should == '200 OK'
    response.body.should include('Settings - Administration')
  end
end
