require 'rails_helper'

RSpec.describe DefaultBoardBuilder do
  describe '.build' do
    subject(:method_call) { described_class.build(params) }

    let(:params) { { name: name } }

    let(:name) { 'This is a new board' }

    it { is_expected.to have_attributes(name: name) }

    it { is_expected.not_to be_persisted }

    it 'contains correct lists' do
      expect(method_call.lists).to match_array [
        have_attributes(name: 'Start Doing', position: 0),
        have_attributes(name: 'Stop Doing', position: 1),
        have_attributes(name: 'Continue Doing', position: 2)
      ]
    end
  end
end
