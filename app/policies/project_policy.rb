class ProjectPolicy < ApplicationPolicy
  def new_github?
    true
  end

  def create?
    new_github?
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
