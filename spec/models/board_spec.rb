require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:class_instance) { described_class.create(name: 'My board') }

  describe 'Validation' do
    it { is_expected.to allow_value('').for(:name) }

    it { is_expected.to validate_length_of(:name).is_at_most(32) }
  end

  describe 'DB' do
    it { is_expected.to have_many(:lists).inverse_of(:board).dependent(:destroy) }

    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  describe '#stream_tag' do
    subject(:metohd_call) { class_instance.stream_tag }

    it { is_expected.to eq("Board:#{class_instance.id}") }
  end

  describe '#lists' do
    subject(:metohd_call) { class_instance.lists }

    let!(:list_1) { create(:list, board: class_instance, position: 2) }
    let!(:list_2) { create(:list, board: class_instance, position: 1) }
    let!(:list_3) { create(:list, board: class_instance, position: 3) }

    it 'returns lists in the correct order' do
      expect(metohd_call).to match_array [list_2, list_1, list_3]
    end
  end
end
