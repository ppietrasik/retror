require 'rails_helper'

describe 'Board/Lists -> Show' do
  subject(:visit_page) { visit board_path(board) }

  let(:board) { list.board }
  let(:list) { create(:list, name: name) }

  let(:name) { 'My List' }

  it 'displays existing list' do
    visit_page

    expect(page).to have_selector("input[value='My List']")
  end

  context 'with multiple lists' do
    let(:second_list_name) { 'My Second List' }

    before { create(:list, board: board, name: second_list_name) }

    it 'displays multiple existing lists', :aggregate_failures do
      visit_page

      expect(page).to have_selector("input[value='My List']")
      expect(page).to have_selector("input[value='My Second List']")
    end
  end
end
