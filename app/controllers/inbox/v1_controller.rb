module Inbox
  class V1Controller < InboxController
    Dry::Schema.load_extensions(:hints)

    ReportSchema = Dry::Schema.Params do
      required(:repo).filled(:string)
      required(:sha).filled(:string)
      required(:branch).filled(:string)
      required(:timestamp).filled(:integer)

      required(:metrics).array(:hash) do
        required(:name).filled(:string)
        optional(:value).filled(:integer)
      end
    end

    def report
      project = Project.find_by!(token: params[:token])
      schema = ReportSchema.(params)
      response_body = { messages: schema.messages.to_h }

      PersistMetricJob.perform_later(project.id, payload: schema.to_h)

      self.response_body = response_body.to_json
      self.status = schema.messages.empty? ? 202 : 400
    end
  end
end
