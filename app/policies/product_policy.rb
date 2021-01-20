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
end
