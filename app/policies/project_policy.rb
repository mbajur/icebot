class ProjectPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    new
  end

  def edit?
    user == record.user
  end

  def update?
    edit?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
