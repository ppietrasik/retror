require 'rails_helper'

RSpec.describe 'DELETE /api/v1/lists/:id -> Destroy the list' do
  subject(:request) { delete "/api/v1/lists/#{id}" }

  let!(:list) { create(:list) }
  let(:id) { list.id }

  it 'destroys the list' do
    expect { request }.to change(List, :count).from(1).to(0)
  end

  it 'returns proper response', :aggregate_failures do
    request

    expect(response).to have_http_status(:no_content)
    expect(response.body).to be_empty
  end

  it 'broadcasts correct message' do
    allow(StreamChannel).to receive(:broadcast_message)
    request

    expect(StreamChannel).to have_received(:broadcast_message).with(list.board, list.stream_tag, 'DeleteList', nil)
  end

  context 'with non-existing id' do
    let(:id) { "#{list.id}-a" }

    it 'returns proper response' do
      request

      expect(response).to have_http_status(:not_found)
    end

    it 'does not destroy the list' do
      expect { request }.not_to change(List, :count)
    end
  end
end
