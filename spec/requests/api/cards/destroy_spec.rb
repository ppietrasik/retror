require 'rails_helper'

RSpec.describe 'DELETE /api/v1/cards/:id -> Destroy the card' do
  subject(:request) { delete "/api/v1/cards/#{id}" }

  let!(:card) { create(:card) }
  let(:id) { card.id }

  it 'destroys the card' do
    expect { request }.to change(Card, :count).from(1).to(0)
  end

  it 'returns proper response', :aggregate_failures do
    request

    expect(response).to have_http_status(:no_content)
    expect(response.body).to be_empty
  end

  it 'broadcasts correct message' do
    allow(StreamChannel).to receive(:broadcast_message)
    request

    expect(StreamChannel).to have_received(:broadcast_message).with(card.board, card.stream_tag, 'DeleteCard', nil)
  end

  context 'with non-existing id' do
    let(:id) { "#{card.id}-a" }

    it 'returns proper response' do
      request

      expect(response).to have_http_status(:not_found)
    end

    it 'does not destroy the card' do
      expect { request }.not_to change(Card, :count)
    end
  end
end
