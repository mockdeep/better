require 'spec_helper'

describe NewsController, "index" do
  it 'works' do
    get(:index)

    response.should be_success
  end
end
