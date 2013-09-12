require 'spec_helper'

describe Workflow do

  let(:workflow) { Factory.build(:workflow) }

  belongs_to :role
  belongs_to :old_status, :class_name => 'IssueStatus', :foreign_key => 'old_status_id'
  belongs_to :new_status, :class_name => 'IssueStatus', :foreign_key => 'new_status_id'

  it { should belong_to(:role) }
  it { should belong_to(:old_status) }
  it { should belong_to(:new_status) }
  
end
