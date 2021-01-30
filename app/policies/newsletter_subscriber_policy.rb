class NewsletterSubscriberPolicy < ApplicationPolicy
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

  def create?
    true
  end
end
