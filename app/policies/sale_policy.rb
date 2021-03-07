class SalePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    if user.manager
      true
    end
  end

  def show?
    if user.manager
      true
    end
  end

  def new?
    if user.manager
      true
    end
  end

  def create?
    if user.manager
      true
    end
  end

  def edit?
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
