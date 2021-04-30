require 'rails_helper'

RSpec.describe 'POST /api/v1/lists/:list_id/cards -> Create a new card' do
  subject(:request) { post "/api/v1/lists/#{list_id}/cards", params: params }

  let(:params) { { note: note } }

  let(:list) { create(:list) }
  let(:list_id) { list.id }

  let(:note) { 'abc' }

  it 'creates a new card' do
    expect { request }.to change(Card, :count).from(0).to(1)
  end

  it 'creates card with proper values' do
    request

    created_card = Card.last
    expect(created_card).to have_attributes(note: note)
  end

  it 'returns proper response', :aggregate_failures do
    request

    created_card = Card.last

    expect(response).to have_http_status(:created)
    expect(json_response).to match(card_object(created_card))
  end

  it 'enqueues correct broadcast job' do
    request

    created_card = Card.last
    renderings = { partial: 'cards/card', locals: { card: created_card } }
    expect(Stream::RenderBroadcastJob).to have_been_enqueued.with(list.board, list.stream_tag, 'NewCard', renderings)
  end

  context 'with non-existing list_id' do
    let(:list_id) { "#{list.id}-a" }

    it 'returns proper response' do
      request

      expect(response).to have_http_status(:not_found)
    end

    it 'does not create a new card' do
      expect { request }.not_to change(Card, :count)
    end
  end

  context 'with too long note param' do
    let(:note) { 'x' * 256 }

    it 'does not create a new card' do
      expect { request }.not_to change(Card, :count)
    end

    it 'returns proper response', :aggregate_failures do
      request

      expect(response).to have_http_status(:bad_request)
      expect(json_response['errors']).to match({ 'note' => ['size cannot be greater than 255'] })
    end

    it 'does not enqueues any job' do
      expect { request }.not_to have_enqueued_job
    end
  end

  def card_object(card)
    {
      'id' => card.id,
      'note' => card.note,
      'position' => card.position
    }
  end
end
