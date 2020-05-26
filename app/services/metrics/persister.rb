# typed: true

module Metrics
  class Persister
    METRICS_KEYS = [
      'types.input.files.sigil.ignore',
      'types.input.files.sigil.false',
      'types.input.files.sigil.true',
      'types.input.files.sigil.strict',
      'types.input.files.sigil.strong',

      'types.input.sends.total',
      'types.input.sends.typed'
    ]

    def initialize(project, payload:)
      @project = project
      @timestamp = Time.at(payload[:timestamp]).to_datetime
      @payload = payload
    end

    def call
      args = {
        created_at: timestamp.beginning_of_hour,
        branch:     payload[:branch]
      }

      metric = project.metrics.find_or_create_by(args)
      metric.update(body: metrics)

      metric
    end

    private

    attr_reader :project
    attr_reader :timestamp
    attr_reader :payload

    def metrics
      @metrics ||= payload[:metrics].each_with_object({}) do |item, hsh|
        hsh[item[:name]] = item[:value] || 0
      end.select { |k| METRICS_KEYS.include?(k) }
    end
  end
end
