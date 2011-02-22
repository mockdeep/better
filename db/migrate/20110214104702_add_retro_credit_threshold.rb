class AddRetroCreditThreshold < ActiveRecord::Migration
  def self.up
    add_column :projects, :retro_credit_threshold, :integer, :default => 3000
    Project.update_all :retro_credit_threshold => 3000
  end

  def self.down
    remove_column :projects, :retro_credit_threshold
  end
end
