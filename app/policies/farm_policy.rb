class FarmPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    if user.farm.id == record.id && user.worker
      true
    end
  end
end
