# BetterMeans - Work 2.0
# Copyright (C) 2006-2011  See readme for details and license#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class SettingsController < ApplicationController

  layout 'admin'

  before_filter :require_admin

  def index # cover_me heckle_me
    edit
    render :action => 'edit'
  end

  def edit # cover_me heckle_me
    @notifiables = %w(issue_added issue_updated news_added document_added file_added message_posted wiki_content_added wiki_content_updated)
    if request.post? && params[:settings] && params[:settings].is_a?(Hash)
      settings = (params[:settings] || {}).dup.symbolize_keys
      settings.each do |name, value|
        # remove blank values in array settings
        value.delete_if {|v| v.blank? } if value.is_a?(Array)
        Setting[name] = value
      end
      flash[:success] = l(:notice_successful_update)
      redirect_to :action => 'edit', :tab => params[:tab]
      return
    end
    @options = {}
    @options[:user_format] = User::USER_FORMATS.keys.collect {|f| [User.current.name(f), f.to_s] }
    @deliveries = ActionMailer::Base.perform_deliveries

    @guessed_host_and_path = request.host_with_port.dup
    @guessed_host_and_path << ('/'+ Redmine::Utils.relative_url_root.gsub(%r{^\/}, '')) unless Redmine::Utils.relative_url_root.blank?
  end

  def plugin # spec_me cover_me heckle_me
    @plugin = Redmine::Plugin.find(params[:id])
    if request.post?
      Setting["plugin_#{@plugin.id}"] = params[:settings]
      flash.now[:success] = l(:notice_successful_update)
      redirect_to :action => 'plugin', :id => @plugin.id
    end
    @partial = @plugin.settings[:partial]
    @settings = Setting["plugin_#{@plugin.id}"]
  rescue Redmine::PluginNotFound
    render_404
  end
end
