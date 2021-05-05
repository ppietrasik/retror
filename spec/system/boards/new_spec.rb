require 'rails_helper'

describe 'Boards -> New' do
  subject(:press_create) do
    fill_in 'board[name]', with: name
    click_on 'Create'
  end

  let(:name) { 'My Board' }

  before { visit new_board_path }

  it 'allows to creates new board', :aggregate_failures do
    expect { press_create }.to change(Board, :count).from(0).to(1)

    expect(page).to have_text 'My Board'
    expect(page).to have_current_path(board_path(Board.first))
  end

  it 'contains default setup lists', :aggregate_failures do
    press_create

    expect(page).to have_selector("input[value='Start Doing']")
    expect(page).to have_selector("input[value='Stop Doing']")
    expect(page).to have_selector("input[value='Continue Doing']")
  end

  context 'with default setup unchecked' do
    before { uncheck 'board[default_setup]' }

    it 'does not contains default setup lists', :aggregate_failures do
      press_create

      expect(page).not_to have_selector("input[value='Start Doing']")
      expect(page).not_to have_selector("input[value='Stop Doing']")
      expect(page).not_to have_selector("input[value='Continue Doing']")
    end
  end

  describe 'Validations' do
    context 'with name that exceeds maximum number of character' do
      let(:name) { 'a' * 33 }

      it 'displays correct error', :aggregate_failures do
        expect { press_create }.not_to change(Board, :count)
        expect(page).to have_text 'Name is too long (maximum is 32 characters)'
      end
    end
  end
end
