require 'rails_helper'

RSpec.describe Card, type: :model do
  let(:class_instance) { described_class.create(note: 'My card', list: list) }
  let(:list) { create(:list) }

  describe 'DB' do
    it { is_expected.to belong_to(:list) }

    it { is_expected.to have_db_column(:note).of_type(:text).with_options(null: false) }
  end

  describe '#stream_tag' do
    subject(:metohd_call) { class_instance.stream_tag }

    it { is_expected.to eq("Card:#{class_instance.id}") }
  end

  describe '#board' do
    subject(:metohd_call) { class_instance.board }

    it { is_expected.to eq(list.board) }
  end
end
