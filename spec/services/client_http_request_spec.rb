# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Client::HttpRequest do
  subject(:service_called) { described_class.call(site.url) }

  let(:site) { create(:site, user: create(:user)) }

  before { Timecop.freeze(Time.now.utc) }
  after { Timecop.return }

  context 'with succesfull url' do
    before { stub_valid_request(site.url, 200) }

    it 'returns succesfull status' do
      expect(service_called).to include(status: 'successfull', code: 200, response_time: 0)
    end
  end

  context 'with errored status' do
    before { stub_error_request(site.url) }

    it 'raises error' do
      expect(service_called).to include(status: 'errored')
    end
  end

  describe 'with any status' do
    before { stub_valid_request(site.url, 200) }

    it 'does not work if site is already pinging' do
      site.enabled = false

      expect { service_called }.not_to change(Log, :count)
    end
  end
end
