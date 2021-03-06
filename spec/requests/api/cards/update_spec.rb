require 'rails_helper'

RSpec.describe 'PATCH /api/v1/cards/:id -> Update the card' do
  subject(:request) { patch "/api/v1/cards/#{id}", params: params }

  let(:list) { create(:list) }
  let!(:card) { create(:card, list: list, note: 'Existing note') }
  let!(:next_card) { create(:card, list: list) }

  let(:id) { card.id }
  let(:params) { { note: note, position: position } }

  let(:note) { 'New note' }
  let(:position) { next_card.position }

  shared_examples_for 'valid request' do
    it 'returns proper response', :aggregate_failures do
      request

      updated_card = card.reload

      expect(response).to have_http_status(:ok)
      expect(json_response).to match(card_object(updated_card))
    end

    it 'does not create a new card' do
      expect { request }.to_not change(Card, :count)
    end

    it 'broadcasts correct message' do
      allow(StreamChannel).to receive(:broadcast_message)
      request

      updated_card = card.reload
      data = { note: updated_card.note, position: updated_card.position, list_id: updated_card.list_id }
      expect(StreamChannel).to have_received(:broadcast_message).with(card.board, card.stream_tag, 'UpdateCard', data)
    end
  end

  shared_examples_for 'invalid request' do
    it 'does not perform the update', :aggregate_failures do
      before_attributes = card.attributes

      request

      current_card = card.reload
      expect(current_card).to have_attributes(**before_attributes)
    end

    it 'returns proper status' do
      request

      expect(response).to have_http_status(:bad_request)
    end

    it 'does not broadcasts any message' do
      expect(StreamChannel).not_to receive(:broadcast_message)

      request
    end
  end

  it_behaves_like 'valid request'

  it 'updates the card with proper values' do
    request

    updated_card = card.reload
    expect(updated_card).to have_attributes(note: note, position: position)
  end

  context 'when moving between lists' do
    let(:params) { { position: position, list_id: list_id } }

    let(:second_list) { create(:list, board: list.board) }
    let!(:second_list_card) { create(:card, list: second_list) }

    let(:position) { second_list_card.position }
    let(:list_id) { second_list.id }

    it_behaves_like 'valid request'

    it 'updates the card with proper values' do
      request

      updated_card = card.reload
      expect(updated_card).to have_attributes(position: position, list_id: list_id)
    end

    context 'when list_id does not exsit' do
      let(:list_id) { "#{second_list.id}-a" }

      it_behaves_like 'invalid request'

      it 'returns proper response' do
        request

        expect(json_response['errors']).to match({ 'list_id' => ['not found'] })
      end
    end

    context 'when list_id comes from differet board' do
      let(:second_list) { create(:list) }

      it_behaves_like 'invalid request'

      it 'returns proper response' do
        request

        expect(json_response['errors']).to match({ 'list_id' => ['must be from the same board'] })
      end
    end
  end

  context 'with too long name param' do
    let(:note) { 'x' * 256 }

    it_behaves_like 'invalid request'

    it 'returns proper response' do
      request

      expect(json_response['errors']).to match({ 'note' => ['size cannot be greater than 255'] })
    end
  end

  context 'with too low position param' do
    let(:position) { -1 }

    it_behaves_like 'invalid request'

    it 'returns proper response' do
      request

      expect(json_response['errors']).to match({ 'position' => ['must be greater than or equal to 0'] })
    end
  end

  context 'with non-existing id' do
    let(:id) { "#{card.id}-a" }

    it 'returns proper response' do
      request

      expect(response).to have_http_status(:not_found)
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
