require 'spec_helper'

describe MailsController, "new" do
  it 'works' do
    get(:new)

    response.should be_success
  end
end
