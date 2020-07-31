require 'spec_helper'

describe ApplicationController, '#set_localization' do
  integrate_views(false)

  class TestController < ApplicationController
    def index
    end
  end

  controller_name :test

  before { @existing_locale = I18n.locale }

  after { I18n.locale = @existing_locale }

  it 'sets the locale to locale from params' do
    expect { get(:index, :locale => :es) }.
      to change(I18n, :locale).from(:en).to(:es)
  end

  it 'sets the locale to default when param is not present' do
    I18n.locale = :es

    expect { get(:index) }.
      to change(I18n, :locale).from(:es).to(:en)
  end

  it 'sets the language from the user when logged in' do
    user = Factory.create(:user, :language => 'zh')
    login_as(user)

    expect { get(:index) }.
      to change(I18n, :locale).from(:en).to(:zh)
  end

  it 'sets the language to default when user language not present' do
    user = Factory.create(:user)
    login_as(user)
    I18n.locale = :zh

    expect { get(:index) }.
      to change(I18n, :locale).from(:zh).to(:en)
  end

  it 'sets the language to default when given invalid locale' do
    user = Factory.create(:user, :language => 'boo')
    I18n.locale = :zh
    login_as(user)

    expect { get(:index) }.
      to change(I18n, :locale).from(:zh).to(:en)
  end
end
