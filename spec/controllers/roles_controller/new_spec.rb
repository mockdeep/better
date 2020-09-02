require 'spec_helper'

describe RolesController, '#new' do
  context 'when request is POST' do
    it 'renders the new view when role is not valid' do
      user = Factory.create(:user, :admin => true)
      login_as(user)

      post(:new)

      response.body.should include("New role")
      response.body.should include("Name can&#39;t be blank")
    end
  end
end
