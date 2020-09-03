require 'spec_helper'

describe SettingsController, '#edit' do
  it 'renders notification settings' do
    login_as(Factory.create(:user, :admin => true))

    get(:edit)

    response.body.should include('issue_added')
    response.body.should include('issue_updated')
    response.body.should include('news_added')
  end

  context 'when request is POST' do
    it 'renders the edit view when params[:settings] is not set' do
      login_as(Factory.create(:user, :admin => true))

      post(:edit)

      response.body.should include('Settings - Administration')
    end

    it 'renders the edit view when params[:settings] is not a hash' do
      login_as(Factory.create(:user, :admin => true))

      post(:edit, :settings => 'foo')

      response.body.should include('Settings - Administration')
    end

    it 'updates each setting given' do
      login_as(Factory.create(:user, :admin => true))

      post(:edit, :settings => { :host_name => 'me', :welcome_text => 'hi' })

      Setting[:host_name].should == 'me'
      Setting[:welcome_text].should == 'hi'
    end

    it 'clears blank values from array settings' do
      login_as(Factory.create(:user, :admin => true))

      post(:edit, :settings => { :notified_events => ['issue_added', 'blah', "\n \t"] })

      Setting[:notified_events].should == ['issue_added', 'blah']
    end

    it 'flashes a success message' do
      login_as(Factory.create(:user, :admin => true))

      post(:edit, :settings => {})

      flash[:success].should == I18n.t(:notice_successful_update)
    end

    it 'redirects to the edit view with the same tab' do
      login_as(Factory.create(:user, :admin => true))

      post(:edit, :settings => {}, :tab => 'bloo')

      response.should redirect_to(:action => 'edit', :tab => 'bloo')
    end
  end
end
