class CropPlanLinePolicy < ApplicationPolicy
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

  def update?
    if user.manager || user.worker
      true
    end
  end
end
