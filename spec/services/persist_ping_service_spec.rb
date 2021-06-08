# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersistPingService do
  subject(:service_called) { described_class.call(site) }

  let(:site) { create(:site, user: create(:user)) }
  let(:response) { { status: 'success', response_message: 'OK', response_time: 100 } }
  let(:time) { Time.now.utc }

  before do
    allow(Client::HttpRequest)
      .to receive(:call)
      .with(site.url)
      .and_return(response)
  end

  before { Timecop.freeze(time) }
  after { Timecop.return }

  describe 'Service called with any site' do
    it 'creates log' do
      expect { service_called }.to change(Log, :count).by(1)
    end

    it 'initializes last_pinged_at and set status active' do
      expect { service_called }
        .to change(site, :last_pinged_at).to(time.to_i).and change(site, :status).to('active')
    end

    it 'does not work if site is already pinging' do
      site.enabled = false

      expect { service_called }.not_to change(Log, :count)
    end
  end

  describe 'Service called' do
    context 'when site pinged with code 100-300' do
      it 'creates log with success status' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end
    end

    context 'when site pinged with code 400-500' do
      it 'creates log with failed status' do
        response[:status] = 'failed'
        response[:response_message] = 'Internal Server Error'

        service_called

        expect(site.logs.last).to have_attributes(**response)
      end
    end

    context 'when site pinged with error' do
      let(:response) { { status: 'errored' } }

      it 'creates log with errored status' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end
    end
  end
end
