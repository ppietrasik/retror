require 'rails_helper'

RSpec.describe List, type: :model do
  let(:class_instance) { described_class.create(name: 'My list', board: board) }
  let(:board) { create(:board) }

  describe 'DB' do
    it { is_expected.to belong_to(:board) }

    it { is_expected.to have_many(:cards).inverse_of(:list).dependent(:destroy) }

    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }

    it { is_expected.to have_db_index(%i[board_id position]).unique(true) }
  end

  describe '#stream_tag' do
    subject(:metohd_call) { class_instance.stream_tag }

    it { is_expected.to eq("List:#{class_instance.id}") }
  end
end
