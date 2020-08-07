require 'spec_helper'

describe TodosController, '#destroy' do
  it 'destroys the todo' do
    user = Factory.create(:user)
    login_as(user) # security: any user can delete any todo
    todo = Factory.create(:todo)

    delete(:destroy, :id => todo.id, :issue_id => todo.issue_id)

    Todo.find_by_id(todo.id).should be_nil
  end

  it 'renders the issue when format is json' do
    user = Factory.create(:user)
    login_as(user) # security: any user can delete any todo
    todo = Factory.create(:todo)

    delete(:destroy, :id => todo.id, :issue_id => todo.issue_id, :format => 'js')

    response.body.should == todo.issue.to_dashboard
  end

  it 'redirects to todos index when format is html' do
    user = Factory.create(:user)
    login_as(user) # security: any user can delete any todo
    todo = Factory.create(:todo)

    delete(:destroy, :id => todo.id, :issue_id => todo.issue_id, :format => 'html')

    response.should redirect_to(todos_url)
  end

  it 'renders head :ok when format is xml' do
    user = Factory.create(:user)
    login_as(user) # security: any user can delete any todo
    todo = Factory.create(:todo)

    delete(:destroy, :id => todo.id, :issue_id => todo.issue_id, :format => 'xml')

    response.status.should == "200 OK"
    response.body.should be_blank
  end
end
