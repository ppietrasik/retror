require 'rails_helper'

describe 'Board/Lists/Cards -> Create' do
  subject(:add_card) do
    create_button = find("button[data-action='card-form#openForm']")
    create_button.click

    note_input = find("textarea[data-card-form-target='note']")
    note_input.fill_in(with: note)
    click_on 'Add'

    sleep 0.1 # wait for websocket
  end

  let(:list) { create(:list) }

  let(:note) { 'This is a new Card!' }

  before { visit board_path(list.board) }

  it 'creates a new card' do
    expect { add_card }.to change(Card, :count).from(0).to(1)
  end

  it 'renders the new card in the dom', :aggregate_failures do
    expect(page).to have_no_selector('div[data-card-id-value]')

    add_card
    created_card = Card.last

    expect(page).to have_selector("div[data-card-id-value='#{created_card.id}']")
  end

  context 'with second widow open' do
    let(:second_window) { open_new_window }

    it "renders new list in the second window's dom", :aggregate_failures do
      within_window second_window do
        visit board_path(list.board)
        expect(page).to have_no_selector('div[data-card-id-value]')
      end

      add_card
      created_card = Card.last

      within_window second_window do
        expect(page).to have_selector("div[data-card-id-value='#{created_card.id}']")
      end
    end
  end
end
