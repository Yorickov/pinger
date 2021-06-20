# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChartService do
  let(:site) { create(:site) }

  let(:time1) { Time.local(2021, 6, 12, 15, 12, 16, 50) }
  let(:time2) { time1 + 15.minutes }
  let(:time1_expected) { time1.change(sec: 0) }
  let(:time2_expected) { time2.change(sec: 0) }

  let(:log1) { create(:log, site: site, response_time: 300, created_at: time1) }
  let(:log2) { create(:log, site: site, response_time: 400, created_at: time2) }
  let(:selection) { Log.all }

  let(:average_response) { (log1.response_time + log2.response_time) / 2 }

  describe 'Minute interval' do
    it 'returns data with 2 response_times and max/miv/avg response_time' do
      expected = [
        [[time1_expected, log1.response_time], [time2_expected, log2.response_time]],
        { max: log2.response_time, min: log1.response_time, avg: average_response }
      ]

      expect(described_class.call(selection)).to eq expected
    end
  end

  describe 'Hour interval' do
    let(:options) { { filter: 'hour' } }

    it 'returns data with 1 average response_time and max/miv/avg response_time' do
      expected = [
        [[time1_expected.change(min: 0), average_response]],
        { max: average_response, min: average_response, avg: average_response }
      ]

      expect(described_class.call(selection, options)).to eq expected
    end
  end
end
