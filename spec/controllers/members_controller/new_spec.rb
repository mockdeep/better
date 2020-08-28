require 'spec_helper'

describe MembersController, '#new' do
  it 'redirects to the project settings page when request is GET' do
    user = Factory.create(:user)
    project = Factory.create(:project)
    user.add_to_project(project, Role.administrator)
    login_as(user)

    get(:new, :id => project.id)

    response.should redirect_to(:controller => 'projects', :action => 'settings', :tab => 'members', :id => project.id)
  end

  it 'adds new members to the project given params[:member]' do
    user_1 = Factory.create(:user)
    user_2 = Factory.create(:user)
    project = Factory.create(:project)
    user_1.add_to_project(project, Role.administrator)
    login_as(user_1)

    post(:new, :id => project.id, :member => { :user_id => user_2.id, :role_ids => Role.core_member.id })

    project.all_members.map(&:user).should == [user_1, user_2]
  end

  it 'adds multiple new members to the project given params[:member][:user_ids]' do
    user_1 = Factory.create(:user)
    user_2 = Factory.create(:user)
    user_3 = Factory.create(:user)
    project = Factory.create(:project)
    user_1.add_to_project(project, Role.administrator)
    login_as(user_1)

    post(:new, :id => project.id, :member => { :user_ids => [user_2.id, user_3.id], :role_ids => Role.core_member.id })

    project.all_members.map(&:user).should == [user_1, user_2, user_3]
  end

  it 'renders the members tab with new members highlighted when format is js' do
    user_1 = Factory.create(:user)
    user_2 = Factory.create(:user)
    user_3 = Factory.create(:user)
    project = Factory.create(:project)
    user_1.add_to_project(project, Role.administrator)
    login_as(user_1)

    post(:new, :id => project.id, :member => { :user_ids => [user_2.id, user_3.id], :role_ids => Role.core_member.id }, :format => 'js')

    member_tag_1 = "#member-#{user_1.members.first.id}"
    member_tag_2 = "#member-#{user_2.members.first.id}"
    member_tag_3 = "#member-#{user_3.members.first.id}"
    response.body.should include(member_tag_1)
    response.body.should match(/#{member_tag_2}.*highlight/)
    response.body.should match(/#{member_tag_3}.*highlight/)
  end
end
