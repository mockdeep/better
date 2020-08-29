require 'spec_helper'

describe MailsController, "index" do
  it 'works' do
    get(:index)

    response.should be_success
  end
end
