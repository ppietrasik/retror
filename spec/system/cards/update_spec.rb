require 'rails_helper'

describe 'Board/Lists/Cards -> Update' do
  describe 'Name' do
    subject(:update_note) do
      note_input_element = note_input

      note_input_element.double_click
      note_input_element.fill_in(with: new_note)
      note_input_element.send_keys(:tab)

      sleep 0.1 # wait for websocket
    end

    let(:list) { create(:list) }
    let!(:card) { create(:card, list: list, note: 'Old note') }

    let(:new_note) { 'Updated note' }

    before { visit board_path(list.board) }

    it 'update the card' do
      update_note

      current_card = card.reload
      expect(current_card).to have_attributes(note: new_note)
    end

    it "updates card's note in dom" do
      expect { update_note }.to change(note_input, :value).from('Old note').to(new_note)
    end

    context 'with second widow open' do
      let(:second_window) { open_new_window }

      it "updates cards's note in the second window's dom", :aggregate_failures do
        within_window second_window do
          visit board_path(list.board)

          expect(note_input.value).to eq('Old note')
        end

        update_note

        within_window second_window do
          expect(note_input.value).to eq(new_note)
        end
      end
    end

    def note_input
      find("textarea[data-card-target='note']")
    end
  end
end
