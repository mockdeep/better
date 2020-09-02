require 'spec_helper'

describe EmailUpdatesController, '#create' do
  context 'when params are valid' do
    it 'creates an email update' do
      user = Factory.create(:user)
      login_as(user)

      expect { post(:create, :email_update => { :mail => 'blah' }) }.
        to change(EmailUpdate, :count).by(1)

      EmailUpdate.last.mail.should == 'blah'
    end

    it 'sets the user on the email update' do
      user_1 = Factory.create(:user)
      user_2 = Factory.create(:user)
      login_as(user_1)

      post(:create, :email_update => { :user_id => user_2.id, :mail => 'boo@boo.com' })

      EmailUpdate.last.user.should == user_1
    end

    def expect_enqueued_job(object, method, *args)
      job = Delayed::Job.first
      payload = job.payload_object
      payload.should == Delayed::PerformableMethod.new(object, method, args)
    end

    it 'sends an activation email' do
      user = Factory.create(:user)
      login_as(user)

      expect { post(:create, :email_update => { :mail => 'boo@boo.com' }) }.
        to change(Delayed::Job, :count).by(1)

      expect_enqueued_job(Mailer, :deliver_email_update_activation, EmailUpdate.last)
    end

    it 'flashes a success message' do
      user = Factory.create(:user)
      login_as(user)

      post(:create, :email_update => { :mail => 'boo@boo.com' })

      flash[:success].should == 'Please check boo@boo.com for the activation email'
    end

    it 'redirects to my account' do
      user = Factory.create(:user)
      login_as(user)

      post(:create, :email_update => { :mail => 'boo@boo.com' })

      response.should redirect_to(:controller => :my, :action => :account)

    end
  end

  context 'when params are invalid' do
    it 'flashes an error message' do
      flash.stub(:sweep)
      user = Factory.create(:user)
      login_as(user)

      post(:create)

      flash.now[:error].should == "Couldn't create email update"
    end

    it 'renders the new page' do
      user = Factory.create(:user)
      login_as(user)

      post(:create)

      response.body.should include('Your new email address')
    end
  end
end
