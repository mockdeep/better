class MailsController < ApplicationController

  before_filter :set_user

  def index # cover_me heckle_me
    if params[:mailbox] == "sent"
      @mails = @user.sent_messages
    else
      @mails = @user.received_messages
    end
  end

  def show # spec_me cover_me heckle_me
    @mail = Mail.read_and_get(params[:id], User.current)
  end

  def new # cover_me heckle_me
    @mail = Mail.new

    if params[:reply_to]
      @reply_to = @user.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @mail.to = @reply_to.sender.login
        @mail.subject = "Re: #{@reply_to.subject}"
        @mail.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    end
  end

  def create # spec_me cover_me heckle_me
    @mail = Mail.new(params[:mail])
    @mail.sender = @user
    @mail.recipient = User.find_by_login(params[:mail][:to])

    if @mail.save
      flash.now[:success] = "Message sent"
      redirect_to user_mails_path(@user)
    else
      render :action => :new
    end
  end

  def delete_selected # cover_me heckle_me
    if params[:delete]
      params[:delete].each { |id|
        @mail = Mail.find(:first, :conditions => ["mails.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @user, @user])
        @mail.mark_deleted(@user) unless @mail.nil?
      }
      flash[:success] = "Messages deleted"
    end
    redirect_to user_mails_path(@user)
  end

  private

  def set_user # cover_me heckle_me
    @user = User.current
  end

end
