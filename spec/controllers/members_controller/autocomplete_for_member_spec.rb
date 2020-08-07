require 'spec_helper'

describe MembersController, '#autocomplete_for_member' do
  it 'finds users matching query' do
    user_1 = Factory.create(:user)
    login_as(user_1)
    project = Factory.create(:project)
    user_1.add_to_project(project, Role.board)
    user_2 = Factory.create(:user, :login => 'foo')
    Factory.create(:user, :login => 'bar')

    get(:autocomplete_for_member, :q => 'fo', :id => project.id)

    assigns(:users).should == [user_2]
  end

  it 'limits results to 100' do
    user_1 = Factory.create(:user)
    login_as(user_1)
    project = Factory.create(:project)
    user_1.add_to_project(project, Role.board)
    users = []
    101.times do |i|
      users << Factory.create(:user, :login => "foo_#{i.to_s.rjust(3, '0')}")
    end

    get(:autocomplete_for_member, :q => 'foo', :id => project.id)

    assigns(:users).map(&:login).should == users[0...-1].map(&:login)
  end

  it 'filters out users already on the project' do
    user_1 = Factory.create(:user)
    user_2 = Factory.create(:user, :login => 'foo_1')
    user_3 = Factory.create(:user, :login => 'foo_2')
    project = Factory.create(:project)
    user_1.add_to_project(project, Role.board)
    user_2.add_to_project(project, Role.member)
    login_as(user_1)

    get(:autocomplete_for_member, :q => 'fo', :id => project.id)

    assigns(:users).should == [user_3]
  end

  it 'renders without a layout' do
    user_1 = Factory.create(:user)
    project = Factory.create(:project)
    user_1.add_to_project(project, Role.board)
    login_as(user_1)

    get(:autocomplete_for_member, :q => 'fo', :id => project.id)

    response.layout.should be_nil
  end
end
