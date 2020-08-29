require 'spec_helper'

describe SearchController, "index" do
  it 'works' do
    get(:index)

    response.should be_success
  end
end
