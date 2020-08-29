require 'spec_helper'

describe WelcomeController, "robots" do
  it 'works' do
    get(:robots)

    response.should be_success
  end
end
