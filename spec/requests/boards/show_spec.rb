require 'rails_helper'

RSpec.describe 'GET /boards/:id -> Renders show board template' do
  subject { get "/boards/#{id}" }

  let(:board) { create(:board) }
  let(:id) { board.id }

  it 'renders correct template' do
    subject

    expect(response).to render_template(:show)
  end
end
