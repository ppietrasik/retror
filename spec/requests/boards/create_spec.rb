require 'rails_helper'

RSpec.describe 'POST /boards -> Create new board' do
  subject { post '/boards', params: params }

  let(:params) { { board: { name: name } } }

  context 'with valid parameters' do
    let(:name) { 'abc' }

    it 'creates a new Board' do
      expect { subject }.to change(Board, :count).by(1)
    end

    it 'redirects correctly' do
      subject

      expect(response).to redirect_to(board_url(Board.last))
    end
  end

  context 'with too long name' do
    let(:name) { 'x' * 33 }

    it 'does not create a new Board' do
      expect { subject }.not_to change(Board, :count)
    end

    it 'renders correct template' do
      subject
  
      expect(response).to render_template(:new)
    end
  end
end
