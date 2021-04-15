class EventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    if user.worker
      true
    end
  end

  def edit?
    if user.worker
      true
    end
  end

  def update?
    if user.worker
      true
    end
  end

  def create?
    if user.worker
      true
    end
  end

  def destroy?
    if user.worker
      true
    end
  end

  def events_multiple_update?
    if user.worker
      true
    end
  end
end
