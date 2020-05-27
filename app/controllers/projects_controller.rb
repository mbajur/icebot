# typed: strict
class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    metrics = @project.metrics.group_by_hour(:created_at, series: false)

    ignore = metrics.sum("cast(body ->> 'types.input.files.sigil.ignore' as integer)")
    strict = metrics.sum("cast(body ->> 'types.input.files.sigil.strict' as integer)")
    trued = metrics.sum("cast(body ->> 'types.input.files.sigil.true' as integer)")
    falsed = metrics.sum("cast(body ->> 'types.input.files.sigil.false' as integer)")
    strong = metrics.sum("cast(body ->> 'types.input.files.sigil.strong' as integer)")
    total = metrics.sum("cast(body ->> 'types.input.sends.total' as integer)")
    typed = metrics.sum("cast(body ->> 'types.input.sends.typed' as integer)")

    @data = [
      { name: 'ignore', data: ignore },
      { name: 'strict', data: strict },
      { name: 'true', data: trued },
      { name: 'false', data: falsed },
      { name: 'strong', data: strong },
      { name: 'total', data: total },
      { name: 'typed', data: typed },
    ]
  end
end
