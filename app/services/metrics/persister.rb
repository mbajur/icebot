# typed: true

module Metrics
  class Persister
    extend T::Sig

    METRICS_KEYS = [
      'types.input.files.sigil.ignore',
      'types.input.files.sigil.false',
      'types.input.files.sigil.true',
      'types.input.files.sigil.strict',
      'types.input.files.sigil.strong',

      'types.input.sends.total',
      'types.input.sends.typed'
    ]

    sig { params(project: Project, payload: Hash).void }
    def initialize(project, payload:)
      @project = project
      @timestamp = Time.at(payload[:timestamp]).to_datetime
      @payload = payload
    end

    sig { returns(Metric) }
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

    sig { returns(Hash) }
    def metrics
      @metrics ||= payload[:metrics].each_with_object({}) do |item, hsh|
        key = cleanup_key(item[:name])
        hsh[key] = item[:value] || 0
      end.select { |k| METRICS_KEYS.include?(k) }
    end

    sig { params(key: String).returns(String) }
    def cleanup_key(key)
      key.split('..').last
    end
  end
end
