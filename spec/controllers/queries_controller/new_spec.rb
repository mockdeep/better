require 'spec_helper'

describe QueriesController, '#new' do
  it 'renders the new template' do
    get(:new)

    response.body.should include(I18n.t(:label_query_new))
  end
end
