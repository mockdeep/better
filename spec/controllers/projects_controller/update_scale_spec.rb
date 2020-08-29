require 'spec_helper'

describe ProjectsController, "update_scale" do
  it 'works' do
    get(:update_scale)

    response.should be_success
  end
end
