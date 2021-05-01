require 'rails_helper'

describe 'Board/Lists -> Destroy' do
  subject(:destroy_list) do
    dropdown_button = find("button[data-action='dropdown#toggle']")
    dropdown_button.click
    
    click_on 'Delete'
    sleep 0.1 # wait for websocket
  end

  let!(:list) { create(:list) }
  let(:board) { list.board }

  before { visit board_path(board) }

  it 'creates new list' do
    expect { destroy_list }.to change(List, :count).from(1).to(0)
  end

  it 'removes the list from dom', :aggregate_failures do
    expect(page).to have_selector("div[data-list-id-value='#{list.id}']")

    destroy_list

    expect(page).not_to have_selector("div[data-list-id-value='#{list.id}']")
  end

  context 'with second widow open' do
    let(:second_window) { open_new_window }

    it "removes the list from the second window's dom", :aggregate_failures do
      within_window second_window do
        visit board_path(board)
        expect(page).to have_selector("div[data-list-id-value='#{list.id}']")
      end

      destroy_list

      within_window second_window do
        expect(page).not_to have_selector("div[data-list-id-value='#{list.id}']")
      end
    end
  end
end
