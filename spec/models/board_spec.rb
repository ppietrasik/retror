require 'rails_helper'

RSpec.describe Board, type: :model do
  let(:class_instance) { described_class.create(name: 'My board') }

  describe 'Validation' do
    it { is_expected.to allow_value('').for(:name) }

    it { is_expected.to validate_length_of(:name).is_at_most(32) }
  end

  describe 'DB' do
    it { is_expected.to have_many(:lists).dependent(:destroy) }

    it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
  end

  describe '#stream_tag' do
    subject(:metohd_call) { class_instance.stream_tag }

    it { is_expected.to eq("Board:#{class_instance.id}") }
  end
end
