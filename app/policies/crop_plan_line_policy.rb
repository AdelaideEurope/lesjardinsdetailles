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
end