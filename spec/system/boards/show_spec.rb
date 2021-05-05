require 'rails_helper'

describe 'Boards -> Show' do
  let(:board) { create(:board, name: name) }
  let(:name) { 'My Board' }

  before { visit board_path(board) }

  it 'displays existing board' do
    expect(page).to have_text 'My Board'
  end

  it 'contains correct stream_id in metatag' do
    board_stream_id = Stream.signed_id(board)
    expect(page).to have_selector("meta[name='stream-id'][content='#{board_stream_id}']", visible: :all)
  end
end
