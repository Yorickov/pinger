# frozen_string_literal: true

describe Whenever::Test::Schedule do
  it 'cron is registered' do
    schedule = Whenever::Test::Schedule.new(file: 'config/schedule.rb')

    assert_equal 1, schedule.jobs[:runner].count
  end
end
