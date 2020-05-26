class PersistMetricJob < ApplicationJob
  queue_as :default

  def perform(project_id, payload: schema)
    project = Project.find(project_id)

    Metrics::Persister.new(project, payload: payload).call
  end
end
