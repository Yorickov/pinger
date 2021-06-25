# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PingSiteService do
  subject(:service_called) { described_class.call(site) }

  let(:site) { create(:site) }
  let(:response) { { status: Log::STATE_SUCCESS, response_message: 'OK', response_time: 100 } }
  let(:saved_response) { { **response, status: response[:status].to_s } }
  let(:checking_string) { Faker::Lorem.word }

  # TODO: uncomment after mailer-config fro prod
  # before { mock_notification(site) }

  describe 'Called service calls http-request client to ping site' do
    before { stub_valid_request(site.full_url, 200) }

    context 'without checking string' do
      it 'calls Http Client' do
        expect(HttpClient)
          .to receive(:call)
          .with(site.full_url, { timeout: site.timeout, checking_string: '' })
          .and_call_original

        service_called
      end
    end

    context 'with checking string' do
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

    context 'when site pinged with code 100-300 with fast response' do
      it 'creates log with success status' do
        service_called

        expect(site.logs.last).to have_attributes(**saved_response)
      end

      it 'sets site status to :up' do
        expect { service_called }.to change(site, :status).to(Site::STATE_UP.to_s)
      end
    end

    context 'when site pinged with code 100-300 with slow response' do
      before { response[:response_time] = 600 }

      it 'creates log with :success status' do
        service_called

        expect(site.logs.last).to have_attributes(**saved_response)
      end

      it 'sets site status to :slow' do
        expect { service_called }.to change(site, :status).to(Site::STATE_SLOW.to_s)
      end
    end

    context 'when site pinged with code 400-500' do
      let(:response) { { status: Log::STATE_FAILED, response_message: 'Internal Server Error' } }

      it 'creates log with :failed status' do
        service_called

        expect(site.logs.last).to have_attributes(**saved_response)
      end

      it 'set site status to :down' do
        expect { service_called }.to change(site, :status).to(Site::STATE_DOWN.to_s)
      end
    end

    context 'when checking content missing' do
      let(:response) do
        { status: Log::STATE_CONTENT_MISSING, response_message: 'Checking content: <string> missing' }
      end

      it 'creates log with :content_missing status' do
        service_called

        expect(site.logs.last).to have_attributes(**saved_response)
      end

      it 'set site status to :down' do
        expect { service_called }.to change(site, :status).to(Site::STATE_DOWN.to_s)
      end
    end

    context 'when site pinged with error' do
      let(:site) { create(:site, :up) }
      let(:response) { { status: Log::STATE_ERRORED } }

      it 'creates log with :errored status' do
        service_called

        expect(site.logs.last).to have_attributes(**saved_response)
      end

      it 'set site status to :inactive' do
        expect { service_called }.to change(site, :status).to(Site::STATE_INACTIVE.to_s)
      end
    end

    context 'when site pinged with timeout error' do
      let(:site) { create(:site, :up) }
      let(:response) { { status: Log::STATE_TIMEOUT_ERROR } }

      it 'creates log with :errored status' do
        service_called

        expect(site.logs.last).to have_attributes(**saved_response)
      end

      it 'set site status to :inactive' do
        expect { service_called }.to change(site, :status).to(Site::STATE_INACTIVE.to_s)
      end
    end
  end
end
