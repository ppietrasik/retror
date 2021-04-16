require 'rails_helper'

RSpec.describe 'GET /boards/new -> Renders new board template' do
  subject { get '/boards/new' }

  it 'renders correct template' do
    subject

    expect(response).to render_template(:new)
  end
end
