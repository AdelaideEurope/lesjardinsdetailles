class PagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def about?
    true
  end

  def home?
    true
  end

  def dashboard?
    if user.worker
      true
    end
  end
end
