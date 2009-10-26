# Redmine - project management software
# Copyright (C) 2006-2009  Shereef Bishay
#

class CustomFieldsController < ApplicationController
  before_filter :require_admin

  def index
    @custom_fields_by_type = CustomField.find(:all).group_by {|f| f.class.name }
    @tab = params[:tab] || 'IssueCustomField'
  end
  
  def new
    @custom_field = begin
      if params[:type].to_s.match(/.+CustomField$/)
        params[:type].to_s.constantize.new(params[:custom_field])
      end
    rescue
    end
    redirect_to(:action => 'index') and return unless @custom_field.is_a?(CustomField)
    
    if request.post? and @custom_field.save
      flash[:notice] = l(:notice_successful_create)
      call_hook(:controller_custom_fields_new_after_save, :params => params, :custom_field => @custom_field)
      redirect_to :action => 'index', :tab => @custom_field.class.name
    end
    @trackers = Tracker.find(:all, :order => 'position')
  end

  def edit
    @custom_field = CustomField.find(params[:id])
    if request.post? and @custom_field.update_attributes(params[:custom_field])
      flash[:notice] = l(:notice_successful_update)
      call_hook(:controller_custom_fields_edit_after_save, :params => params, :custom_field => @custom_field)
      redirect_to :action => 'index', :tab => @custom_field.class.name
    end
    @trackers = Tracker.find(:all, :order => 'position')
  end
  
  def destroy
    @custom_field = CustomField.find(params[:id]).destroy
    redirect_to :action => 'index', :tab => @custom_field.class.name
  rescue
    flash[:error] = "Unable to delete custom field"
    redirect_to :action => 'index'
  end
end
