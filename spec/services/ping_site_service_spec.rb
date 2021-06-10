# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingSiteService do
  subject(:service_called) { described_class.call(site) }

  let(:site) { create(:site, user: create(:user)) }
  let(:response) { { status: 'success', response_message: 'OK', response_time: 100 } }
  let(:time) { Time.now.utc }

  before { mock_ping_http_client(site, response) }

  before { Timecop.freeze(time) }
  after { Timecop.return }

  describe 'Service called with any site' do
    it 'creates log' do
      expect { service_called }.to change(Log, :count).by(1)
    end
  end

  describe 'Service called' do
    context 'when site pinged with code 100-300' do
      it 'creates log with success status and sets site status active' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end

      it 'sets status active' do
        expect { service_called }
          .to change(site, :status).to('active')
      end
    end

    context 'when site pinged with code 400-500' do
      let(:response) { { status: 'failed', response_message: 'Internal Server Error' } }

      it 'creates log with failed status' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end

      it 'remain status inactive' do
        expect { service_called }
          .not_to change(site, :status)
      end
    end

    context 'when site pinged with error' do
      let(:response) { { status: 'errored' } }

      it 'creates log with errored status' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end

      it 'remain status inactive' do
        expect { service_called }
          .not_to change(site, :status)
      end
    end
  end
end
