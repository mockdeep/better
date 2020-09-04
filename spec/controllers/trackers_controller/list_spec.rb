require 'spec_helper'

describe TrackersController, '#list' do
  it 'renders the list view with no layout when request is xhr' do
    login_as(Factory.create(:user, :admin => true))

    xhr(:get, :list)

    response.body.should include('Types')
    response.body.should_not include('Administration')
  end

  it 'renders the list view with layout when request is not xhr' do
    login_as(Factory.create(:user, :admin => true))

    get(:list)

    response.body.should include('Types')
    response.body.should include('Administration')
  end

  it 'displays trackers paginated' do
    login_as(Factory.create(:user, :admin => true))
    (11 - Tracker.count).times do
      Factory.create(:tracker)
    end

    get(:list)

    Tracker.find(:all, :order => :id, :limit => 10).each do |tracker|
      response.body.should include(tracker.name)
    end

    response.body.should_not include(Tracker.find(:last, :order => :id).name)
    response.body.should include('Next')
  end
end
