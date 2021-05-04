require 'rails_helper'

RSpec.describe 'PATCH /api/v1/lists/:id -> Update the list' do
  subject(:request) { patch "/api/v1/lists/#{id}", params: params }

  let(:id) { list.id }
  let(:params) { { name: name, position: position } }

  let!(:list) { create(:list, name: 'Existing list name') }
  let!(:next_list) { create(:list, board: list.board) }

  let(:name) { 'New name' }
  let(:position) { next_list.position }

  shared_examples_for 'invalid request' do
    it 'does not perform the update', :aggregate_failures do
      before_attributes = list.attributes

      request

      current_list = list.reload
      expect(current_list).to have_attributes(**before_attributes)
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

  it 'updates the list with proper values' do
    request

    updated_list = list.reload
    expect(updated_list).to have_attributes(name: name, position: position)
  end

  it 'returns proper response', :aggregate_failures do
    request

    updated_list = list.reload

    expect(response).to have_http_status(:ok)
    expect(json_response).to match(list_object(updated_list))
  end

  it 'does not create new list' do
    expect { request }.to_not change(List, :count)
  end

  it 'broadcasts correct message' do
    allow(StreamChannel).to receive(:broadcast_message)
    request

    updated_list = list.reload
    data = { name: updated_list.name, position: updated_list.position }
    expect(StreamChannel).to have_received(:broadcast_message).with(list.board, list.stream_tag, 'UpdateList', data)
  end

  context 'with too long name param' do
    let(:name) { 'x' * 25 }

    it_behaves_like 'invalid request'

    it 'returns proper response' do
      request

      expect(json_response['errors']).to match({ 'name' => ['size cannot be greater than 24'] })
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
    let(:id) { "#{list.id}-a" }

    it 'returns proper response' do
      request

      expect(response).to have_http_status(:not_found)
    end
  end

  def list_object(list)
    {
      'id' => list.id,
      'name' => list.name,
      'position' => list.position
    }
  end
end
