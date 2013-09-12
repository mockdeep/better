

require "spec_helper"

describe Todo do
  let(:todo) { Factory.build(:todo) }

  before(:all) { todo.issue.user.}

  describe "#update_issue_timestamp" do
    it "Updates todo.issue.updated_at to DateTime.now" do
      #finish test
    end
  end
end


