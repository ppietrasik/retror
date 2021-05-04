require 'rails_helper'

RSpec.describe 'POST /boards -> Create new board' do
  subject(:request) { post '/boards', params: params }

  let(:params) { { board: { name: name } } }

  let(:name) { 'abc' }

  it 'creates a new board' do
    expect { request }.to change(Board, :count).from(0).to(1)
  end

  it 'creates board with proper values' do
    request

    created_board = Board.last
    expect(created_board).to have_attributes(name: name)
  end

  it 'redirects correctly' do
    request

    expect(response).to redirect_to(board_url(Board.last))
  end

  context 'with default_setup checked', :aggregate_failures do
    let(:params) { { board: { name: name, default_setup: '1' } } }

    it 'creates board with proper values' do
      request

      created_board = Board.last

      expect(created_board).to have_attributes(name: name)
      expect(created_board.lists).to match_array [
        have_attributes(name: 'Start Doing', position: 0),
        have_attributes(name: 'Stop Doing', position: 1),
        have_attributes(name: 'Continue Doing', position: 2)
      ]
    end
  end

  context 'with too long name' do
    let(:name) { 'x' * 33 }

    it 'does not create a new board' do
      expect { request }.not_to change(Board, :count)
    end

    it 'renders correct template' do
      request

      expect(response).to render_template(:new)
    end
  end
end
