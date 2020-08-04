require 'spec_helper'

describe ApplicationController, '#authorize' do
  integrate_views(false)

  class AuthorizeSpecController < ApplicationController
    def index
      @result = authorize
    end

    def show
      @result = authorize(*params.values_at(:override_controller, :override_action, :override_global))
    end
  end

  controller_name :authorize_spec

  it 'returns true when the format is png' do
    get(:index, :format => 'png')

    assigns(:result).should be(true)
  end

  it 'returns false when user is not authorized' do
    get(:index)

    assigns(:result).should be(false)
  end

  it 'accepts arguments for another controller, action, and global' do
    login_as(Factory.create(:user))

    get(:show,
        :override_controller => 'projects',
        :override_action => 'join',
        :override_global => true)

    assigns(:result).should be(true)
  end
end
