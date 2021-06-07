# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingService do
  subject(:service_called) { described_class.call(site) }

  let(:user) { create(:user) }
  let(:time) { Time.now.utc }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  context 'with succesfull url' do
    let!(:site) { create(:site, user: user) }

    before { stub_valid_request(site.url, 200) }

    it 'returns succesfull status' do
      expect(service_called).to include(status: 'succesfull', code: 200, response_time: 0)
    end

    it 'initialize last_pinged_at' do
      expect { service_called }
        .to change(site, :last_pinged_at).to(time.to_i).and change(site, :status).to('active')
    end
  end

  context 'with errored status' do
    let!(:site) { create(:site, user: user) }

    before { stub_error_request(site.url) }

    it 'raises error' do
      expect(service_called).to include(status: 'errored')
    end

    it 'initialize last_pinged_at' do
      expect { service_called }
        .to change(site, :last_pinged_at).to(time.to_i).and change(site, :status).to('active')
    end
  end
end
