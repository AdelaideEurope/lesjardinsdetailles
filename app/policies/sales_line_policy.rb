class SalesLinePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    if user.manager
      true
    end
  end

  def destroy?
    if user.manager
      true
    end
  end

  def update?
    if user.manager
      true
    end
  end
end
