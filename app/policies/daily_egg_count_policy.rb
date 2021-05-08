class DailyEggCountPolicy < ApplicationPolicy
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

  def show?
    if user.worker
      true
    end
  end

  def new?
    if user.worker
      true
    end
  end

  def create?
    if user.worker
      true
    end
  end
end
