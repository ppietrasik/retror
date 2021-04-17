require 'rails_helper'

describe 'Board/Lists -> Show' do
  subject(:visit_page) { visit board_path(board) }

  let(:board) { list.board }
  let(:list) { create(:list, name: name) }

  let(:name) { 'My List' }

  it 'displays existing list' do
    visit_page

    expect(page).to have_text 'My List'
  end

  context 'with multiple lists' do
    let(:second_list) { create(:list, board: board, name: second_list_name) }
    let(:second_list_name) { 'My Second List' }

    it 'displays multiple existing lists', :aggregate_failures do
      visit_page

      expect(page).to have_text 'My List'
      expect(page).to have_text 'My Second List'
    end
  end
end
