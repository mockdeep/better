# BetterMeans - Work 2.0
# Copyright (C) 2006-2011  See readme for details and license#

class SearchController < ApplicationController

  before_filter :find_optional_project

  helper :messages
  include MessagesHelper

  def index # cover_me heckle_me
    @question = params[:q] || ""
    @question.strip!
    @all_words = params[:all_words] || (params[:submit] ? false : true)
    @titles_only = !params[:titles_only].nil?

    projects_to_search =
      case params[:scope]
      when 'all'
        nil
      when 'my_projects'
        User.current.memberships.collect(&:project)
      when 'subprojects'
        @project ? (@project.self_and_descendants.active) : nil
      else
        @project
      end

    offset = nil
    begin; offset = params[:offset].to_time if params[:offset]; rescue; end

    # quick jump to an issue
    if @question.match(/^#?(\d+)$/) && Issue.visible.find_by_id($1)
      redirect_to :controller => "issues", :action => "show", :id => $1
      return
    end

    @object_types = %w(issues news documents wiki_pages messages projects)
    if projects_to_search.is_a? Project
      # don't search projects
      @object_types.delete('projects')
      # only show what the user is allowed to view
      @object_types = @object_types.select {|o| User.current.allowed_to?("view_#{o}".to_sym, projects_to_search)}
    end

    @scope = @object_types.select {|t| params[t]}
    @scope = @object_types if @scope.empty?

    # extract tokens from the question
    # eg. hello "bye bye" => ["hello", "bye bye"]
    @tokens = @question.scan(%r{((\s|^)"[\s\w]+"(\s|$)|\S+)}).collect {|m| m.first.gsub(%r{(^\s*"\s*|\s*"\s*$)}, '')}
    # tokens must be at least 3 character long
    @tokens = @tokens.uniq.select {|w| w.length > 2 }

    if !@tokens.empty?
      # no more than 5 tokens to search for
      @tokens.slice! 5..-1 if @tokens.size > 5
      # strings used in sql like statement
      like_tokens = @tokens.collect {|w| "%#{w.downcase}%"}

      @results = []
      @results_by_type = Hash.new {|h,k| h[k] = 0}

      limit = 10
      @scope.each do |s|
        r, c = s.singularize.camelcase.constantize.search(like_tokens, projects_to_search,
          :all_words => @all_words,
          :titles_only => @titles_only,
          :limit => (limit+1),
          :offset => offset,
          :before => params[:previous].nil?)
        @results += r
        @results_by_type[s] += c
      end
      @results = @results.sort {|a,b| b.event_datetime <=> a.event_datetime}
      if params[:previous].nil?
        @pagination_previous_date = @results[0].event_datetime if offset && @results[0]
        if @results.size > limit
          @pagination_next_date = @results[limit-1].event_datetime
          @results = @results[0, limit]
        end
      else
        @pagination_next_date = @results[-1].event_datetime if offset && @results[-1]
        if @results.size > limit
          @pagination_previous_date = @results[-(limit)].event_datetime
          @results = @results[-(limit), limit]
        end
      end
    else
      @question = ""
    end
    render :layout => false if request.xhr?
  end

  private

  def find_optional_project # cover_me heckle_me
    return true unless params[:id]
    @project = Project.find(params[:id])
    check_project_privacy
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
