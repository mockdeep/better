require 'spec_helper'

describe MailsController, '#delete_selected' do
  it 'redirects to user_mail_path when no params[:delete] given' do
    post(:delete_selected)

    response.should redirect_to user_mails_path(User.anonymous)
  end

  it 'marks each mail deleted when user is sender' do
    user = User.anonymous
    mail_1 = Factory.create(:mail, :sender => user)
    mail_2 = Factory.create(:mail, :sender => user)

    post(:delete_selected, :delete => [mail_1.id, mail_2.id])

    mail_1.reload.sender_deleted.should be_true
    mail_2.reload.sender_deleted.should be_true
  end

  it 'marks each mail deleted when user is recipient' do
    user = User.anonymous
    mail_1 = Factory.create(:mail, :recipient => user)
    mail_2 = Factory.create(:mail, :recipient => user)

    post(:delete_selected, :delete => [mail_1.id, mail_2.id])

    mail_1.reload.recipient_deleted.should be_true
    mail_2.reload.recipient_deleted.should be_true
  end

  it 'does not mark non-selected mail deleted' do
    user = User.anonymous
    mail_1 = Factory.create(:mail, :recipient => user)
    mail_2 = Factory.create(:mail, :recipient => user)

    post(:delete_selected, :delete => [mail_1.id])

    mail_2.reload
    mail_2.recipient_deleted.should be_false
    mail_2.sender_deleted.should be_false
  end

  it 'does not mark mail deleted when user is not sender or recipient' do
    user = User.anonymous
    mail = Factory.create(:mail)

    post(:delete_selected, :delete => [mail.id])

    mail.reload
    mail.recipient_deleted.should be_false
    mail.sender_deleted.should be_false
  end

  it 'flashes a success message' do
    user = User.anonymous

    post(:delete_selected, :delete => [1])

    flash[:success].should == 'Messages deleted'
  end
end
