# BetterMeans - Work 2.0
# Copyright (C) 2006-2011  See readme for details and license#

class IssueInvitationsController < ApplicationController
  def new # cover_me heckle_me
    @quote = Quote.new

    respond_to do |format|
      format.xml  { render :xml => @quote }
    end
  end

  def create # cover_me heckle_me
    @quote = Quote.new(params[:quote])
    @quote.user_id = User.current.id

    respond_to do |format|
      flash.now[:success] = 'Invitation was successfully created and sent'
      format.html { redirect_to(@quote) }
      format.xml  { render :xml => @quote, :status => :created, :location => @quote }
    end
  end

end
