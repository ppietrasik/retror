require 'rails_helper'

describe 'Board/Lists/Cards -> Destroy' do
  subject(:destroy_card) do
    card_element = find("div[data-card-id-value='#{card.id}']")
    dropdown_button = card_element.find("button[data-action='dropdown#toggle']")
    dropdown_button.click

    click_on 'Delete'
    sleep 0.1 # wait for websocket
  end

  let(:list) { create(:list) }
  let!(:card) { create(:card, list: list) }

  before { visit board_path(list.board) }

  it 'removes the card' do
    expect { destroy_card }.to change(Card, :count).from(1).to(0)
  end

  it 'removes the list from dom', :aggregate_failures do
    expect(page).to have_selector("div[data-card-id-value='#{card.id}']")

    destroy_card

    expect(page).not_to have_selector("div[data-card-id-value='#{card.id}']")
  end

  context 'with second widow open' do
    let(:second_window) { open_new_window }

    it "removes the list from the second window's dom", :aggregate_failures do
      within_window second_window do
        visit board_path(list.board)
        expect(page).to have_selector("div[data-card-id-value='#{card.id}']")
      end

      destroy_card

      within_window second_window do
        expect(page).not_to have_selector("div[data-card-id-value='#{card.id}']")
      end
    end
  end
end
