# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SitesHelper, type: :helper do
  let(:unix_time) { Time.utc(2011, 6, 23, 12, 30, 40) }

  before { Time.zone = 'Europe/Minsk' }

  it 'returns formatted time' do
    expect(helper.format_time(unix_time)).to eq '23-06-2011 15:30'
  end
end
