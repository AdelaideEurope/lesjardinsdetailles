class OutletPolicy < ApplicationPolicy
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

  def last_prices_multiple_new?
    if user.manager
      true
    end
  end

  def last_prices_multiple_create?
    if user.manager
      true
    end
  end
end
