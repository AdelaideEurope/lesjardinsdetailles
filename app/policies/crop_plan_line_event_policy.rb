class CropPlanLineEventPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def update?
    if user.worker
      true
    end
  end
end
