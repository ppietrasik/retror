require 'rails_helper'

describe 'Boards -> Show' do
  subject(:visit_page) { visit board_path(board) }

  let(:board) { create(:board, name: name) }
  let(:name) { 'My Board' }

  it 'displays existing board' do
    visit_page

    expect(page).to have_text 'My Board'
  end
end
