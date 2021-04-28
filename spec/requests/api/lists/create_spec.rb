require 'rails_helper'

RSpec.describe 'POST /api/v1/boards/:board_id/lists -> Create new list' do
  subject(:request) { post "/api/v1/boards/#{board_id}/lists", params: params }

  let(:params) { { name: name } }

  let(:board) { create(:board) }
  let(:board_id) { board.id }

  let(:name) { 'abc' }

  it 'creates a new list' do
    expect { request }.to change(List, :count).from(0).to(1)
  end

  it 'creates list with proper values' do
    request

    created_list = List.last
    expect(created_list).to have_attributes(name: name)
  end

  it 'returns proper response', :aggregate_failures do
    request

    created_list = List.last

    expect(response).to have_http_status(:created)
    expect(json_response).to match(list_object(created_list))
  end

  it 'enqueues correct broadcast job' do
    request

    created_list = List.last
    renderings = { partial: 'lists/list', locals: { list: created_list } }
    expect(Stream::RenderBroadcastJob).to have_been_enqueued.with(board, board.stream_tag, 'NewList', renderings)
  end

  context 'with non-existing board_id' do
    let(:board_id) { "#{board.id}-a" }

    it 'returns proper response' do
      request

      expect(response).to have_http_status(:not_found)
    end

    it 'does not create a new list' do
      expect { request }.not_to change(List, :count)
    end
  end

  context 'with too long name param' do
    let(:name) { 'x' * 33 }

    it 'does not create a new List' do
      expect { request }.not_to change(List, :count)
    end

    it 'returns proper response', :aggregate_failures do
      request

      expect(response).to have_http_status(:bad_request)
      expect(json_response['errors']).to match({ 'name' => ['size cannot be greater than 24'] })
    end

    it 'does not enqueues any job' do
      expect { request }.not_to have_enqueued_job
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
