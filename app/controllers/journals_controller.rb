# BetterMeans - Work 2.0
# Copyright (C) 2006-2011  See readme for details and license
#

class JournalsController < ApplicationController
  before_filter :find_journal

  def edit # cover_me heckle_me
    if request.post?
      @journal.update_attributes(:notes => params[:notes]) if params[:notes]
      if @journal.details.empty? && @journal.notes.blank?
        @journal.destroy
      else
        update_activity_stream(params[:notes]) if params[:notes]
      end

      respond_to do |format|
        format.html { redirect_to :controller => 'issues', :action => 'show', :id => @journal.journalized_id }
        format.js { render :action => 'update' }
      end
    end
  end

  def edit_from_dashboard # spec_me cover_me heckle_me
    if @journal.update_attributes(params[:journal])
      update_activity_stream(params[:journal][:notes])
    end
    respond_to do |format|
      format.js {render :json => @journal.issue.to_dashboard}
    end
  end

  private

  def update_activity_stream(notes) # cover_me heckle_me
    ActivityStream.update_all(["indirect_object_description = ?", notes], {:indirect_object_id => @journal.id,
                                                                            :indirect_object_type => "Journal",
                                                                            :object_type => "Issue",
                                                                            :actor_id => User.current.id},
                                                                          :order => 'created_at DESC', :limit => 1)
  end

  def find_journal # cover_me heckle_me
    @journal = Journal.find(params[:id])
    (render_403; return false) unless @journal.editable_by?(User.current)
    @project = @journal.journalized.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
