class ProductPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    if user.manager || user.worker
      true
    end
  end

  def show?
    if user.manager || user.worker
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

  def product_variets_multiple_new?
    if user.manager
      true
    end
  end

  def product_variets_multiple_create?
    if user.manager
      true
    end
  end
end
