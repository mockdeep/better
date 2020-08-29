require 'spec_helper'

describe ProjectsController, "activity" do
  it 'works' do
    get(:activity)

    response.should be_success
  end
end
