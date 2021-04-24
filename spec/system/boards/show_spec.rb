require 'rails_helper'

describe 'Boards -> Show' do
  subject(:visit_page) { visit board_path(board) }

  let(:board) { create(:board, name: name) }
  let(:name) { 'My Board' }

  it 'displays existing board' do
    visit_page

    expect(page).to have_text 'My Board'
  end

  it 'contains correct stream_id in metatag' do
    board_stream_id = Stream.signed_id(board)
    expect(page).to have_no_selector("meta[name='stream-id'][content='#{board_stream_id}']")
  end
end
