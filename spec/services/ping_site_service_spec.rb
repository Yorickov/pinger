# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingSiteService do
  subject(:service_called) { described_class.call(site) }

  let(:site) { create(:site) }
  let(:response) { { status: 'success', response_message: 'OK', response_time: 100 } }
  let(:checking_string) { Faker::String.random }

  describe 'Called service calls http-request client to ping site' do
    before { stub_valid_request(site.full_url, 200) }

    context 'without checking string' do
      it 'calls Http Client' do
        expect(HttpClient)
          .to receive(:call)
          .with(site.full_url, { timeout: site.timeout, checking_string: nil })
          .and_call_original

        service_called
      end
    end

    context 'with check string' do
      it 'calls Http Client' do
        site.checking_string = checking_string

        expect(HttpClient)
          .to receive(:call)
          .with(site.full_url, { timeout: site.timeout, checking_string: site.checking_string })
          .and_call_original

        service_called
      end
    end
  end

  describe 'Called service creates log and changes site attributes' do
    before { mock_http_client(site.full_url, response, { timeout: 10, checking_string: site.checking_string }) }

    it 'creates log' do
      expect { service_called }.to change(Log, :count).by(1)
    end

    context 'when site pinged with code 100-300' do
      it 'creates log with success status and sets site status active' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end

      it 'sets status active' do
        expect { service_called }.to change(site, :status).to('active')
      end
    end

    context 'when site pinged with code 400-500' do
      let(:response) { { status: 'failed', response_message: 'Internal Server Error' } }

      it 'creates log with failed status' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end

      it 'remain status inactive' do
        expect { service_called }.not_to change(site, :status)
      end
    end

    context 'when checking content missing' do
      let(:response) do
        { status: 'content_missing', response_message: 'Checking content: <string> missing' }
      end

      it 'creates log with failed status' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end

      it 'remain status inactive' do
        expect { service_called }.not_to change(site, :status)
      end
    end

    context 'when site pinged with error' do
      let(:response) { { status: 'errored' } }

      it 'creates log with errored status' do
        service_called

        expect(site.logs.last).to have_attributes(**response)
      end

      it 'remain status inactive' do
        expect { service_called }.not_to change(site, :status)
      end
    end
  end
end
