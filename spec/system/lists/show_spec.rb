require 'rails_helper'

describe 'Board/Lists -> Show' do
  subject(:visit_page) { visit board_path(board) }

  let(:board) { create(:board) }
  let!(:list_1) { create(:list, board: board, name: 'My List') }

  it 'displays existing list' do
    visit_page

    expect(page).to have_selector("input[value='#{list_1.name}']")
  end

  context 'with multiple lists' do
    let!(:list_2) { create(:list, board: board, name: 'My Second List') }
    let!(:list_3) { create(:list, board: board, name: 'My Third List') }

    before do
      list_1.insert_at(1)
      list_2.insert_at(0)
      list_3.insert_at(2)
    end

    it 'displays multiple existing lists', :aggregate_failures do
      visit_page

      expect(page).to have_selector("input[value='#{list_1.name}']")
      expect(page).to have_selector("input[value='#{list_2.name}']")
      expect(page).to have_selector("input[value='#{list_3.name}']")
    end

    it 'displays lists in a correct order', :aggregate_failures do
      visit_page

      list_at_pos_0 = find_list_by_index(0)
      list_at_pos_1 = find_list_by_index(1)
      list_at_pos_2 = find_list_by_index(2)

      expect(list_at_pos_0).to have_selector("input[value='#{list_2.name}']")
      expect(list_at_pos_1).to have_selector("input[value='#{list_1.name}']")
      expect(list_at_pos_2).to have_selector("input[value='#{list_3.name}']")
    end
  end

  def find_list_by_index(index)
    all("div[data-controller='list list-edit']")[index]
  end
end
