require 'rails_helper'

RSpec.describe 'GET /boards/new -> Renders new board template' do
  subject(:request) { get '/boards/new' }

  it 'renders correct template' do
    request

    expect(response).to render_template(:new)
  end
end
