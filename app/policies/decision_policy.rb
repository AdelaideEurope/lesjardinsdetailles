class DecisionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    if user.admin
      true
    end
  end

  def create?
    if user.admin
      true
    end
  end

  def update?
    if user.admin
      true
    end
  end

  def edit?
    if user.admin
      true
    end
  end

  def new?
    if user.admin
      true
    end
  end

  def destroy?
    if user.admin
      true
    end
  end
end
