require 'rails_helper'

describe 'Board/Lists/Cards -> Show' do
  subject(:visit_page) { visit board_path(list.board) }

  let(:list) { create(:list) }

  let!(:card_1) { create(:card, list: list, note: 'My note') }

  it 'displays existing list' do
    visit_page

    expect(find_note_by(card_1)).to eq(card_1.note)
  end

  context 'with multiple lists' do
    let!(:card_2) { create(:card, list: list, note: 'My Second note') }
    let!(:card_3) { create(:card, list: list, note: 'My Third note') }

    it 'displays multiple existing lists', :aggregate_failures do
      visit_page

      expect(find_note_by(card_1)).to eq(card_1.note)
      expect(find_note_by(card_2)).to eq(card_2.note)
      expect(find_note_by(card_3)).to eq(card_3.note)
    end
  end

  def find_note_by(card)
    card = find("div[data-card-id-value='#{card.id}']")
    card.find('textarea').value
  end
end
