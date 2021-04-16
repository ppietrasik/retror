# frozen_string_literal: true

require 'rails_helper'

# Rails don't recognize redirection in routes as a proper route, therefore "route_to" wouldn't work here
RSpec.describe 'Routes -> Root', type: :request do
  subject { get root_path }

  it { is_expected.to redirect_to('/boards/new') }
end
