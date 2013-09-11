require "spec_helper"

describe Board do
  let(:board) { Board.new(:name => "Test Board",
      :description => "test desc",
      :project_id => 1) 
    }
  
  before(:all) board.save
  after(:all) board.delete

  describe "#reset_counters! should call class method" do
    it "runs class method self.reset_counters with Board.id" do
      board.class.should_receive(:reset_counters!).with(board.id)
      board.reset_counters!
    end
  end

end
