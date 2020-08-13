require 'spec_helper'

describe UsersController, '#destroy_membership' do
  it 'does not destroy member when request is not POST' do
    admin_user = Factory.create(:user, :admin => true)
    role = Factory.create(:role)
    member = Factory.create(:member, :roles => [role])
    login_as(admin_user)

    get(:destroy_membership, :id => member.user_id, :membership_id => member.id)

    Member.find_by_id(member.id).should == member
  end

  it 'does not destroy member when not deletable' do
    admin_user = Factory.create(:user, :admin => true)
    role = Factory.create(:role)
    member = Factory.create(:member, :roles => [role])
    member.member_roles.first.update_attributes!(:inherited_from => 52)
    login_as(admin_user)

    post(:destroy_membership, :id => member.user_id, :membership_id => member.id)

    Member.find_by_id(member.id).should == member
  end

  it 'destroys member when POST request and deletable' do
    admin_user = Factory.create(:user, :admin => true)
    role = Factory.create(:role)
    member = Factory.create(:member, :roles => [role])
    login_as(admin_user)

    post(:destroy_membership, :id => member.user_id, :membership_id => member.id)

    Member.find_by_id(member.id).should be_nil
  end

  it 'does not delete the user' do
    admin_user = Factory.create(:user, :admin => true)
    role = Factory.create(:role)
    member = Factory.create(:member, :roles => [role])
    login_as(admin_user)

    post(:destroy_membership, :id => member.user_id, :membership_id => member.id)

    User.find_by_id(member.user_id).should_not be_nil
  end
end
