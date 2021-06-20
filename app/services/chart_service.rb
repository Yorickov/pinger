# frozen_string_literal: true

class ChartService
  FILTERS = %w[minute hour].freeze
  DEFAULT_OPTIONS = { filter: 'minute' }.freeze

  def self.call(*args)
    new(*args).call
  end

  def initialize(logs, options = {})
    @options = DEFAULT_OPTIONS.merge(options)
    validate_options!

    @logs = logs
  end

  def call
    grouped = logs.public_send("group_by_#{options[:filter]}".to_sym, &:created_at)
    chart_data = calc_data(grouped)
    response_values = calc_response_values(chart_data)

    [chart_data, response_values]
  end

  private

  attr_reader :logs, :options

  def calc_data(data)
    data.map { |time, logs| [time, calc_average(logs)] }
  end

  def calc_average(group)
    response_times = group.map(&:response_time).compact
    size = response_times.size
    return 0 if size.zero?
    return response_times.first if size == 1

    response_times.sum / size
  end

  def validate_options!
    raise ArgumentError, 'wrong filter' unless FILTERS.any?(options[:filter])
  end

  def calc_response_values(data)
    size = data.size
    return { max: 0, min: 0, avg: 0 } if size.zero?

    max = data.max_by { |_time, res| res }.last
    min = data.min_by { |_time, res| res }.last
    avg = data.sum { |_time, res| res } / size

    { max: max, min: min, avg: avg }
  end
end
