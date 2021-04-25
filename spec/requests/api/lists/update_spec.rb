require 'rails_helper'

RSpec.describe 'PATCH /api/v1/lists/:id -> Update the list' do
  subject(:request) { patch "/api/v1/lists/#{id}", params: params }

  let(:params) { { name: name } }

  let!(:list) { create(:list, name: 'Existing list name') }
  let(:id) { list.id }

  let(:name) { 'New name' }

  it 'updates the list with proper values' do
    request

    updated_list = list.reload
    expect(updated_list).to have_attributes(name: name)
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

    list = List.last
    expect(StreamChannel).to have_received(:broadcast_message).with(list.board, list.stream_tag, 'UpdateList', { name: list.name })
  end

  context 'with too long name param' do
    let(:name) { 'x' * 33 }

    it 'does not perform the update', :aggregate_failures do
      request

      current_list = list.reload
      expect(current_list).not_to have_attributes(name: name)
    end

    it 'returns proper response', :aggregate_failures do
      request

      expect(response).to have_http_status(:bad_request)
      expect(json_response['errors']).to match({ 'name' => ['is too long (maximum is 24 characters)'] })
    end

    it 'does not broadcasts any message' do
      expect(StreamChannel).not_to receive(:broadcast_message)

      request
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
      'name' => list.name
    }
  end
end
