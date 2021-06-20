# frozen_string_literal: true

class SitePolicy < ApplicationPolicy
  def show?
    user.present? && owner?
  end

  def edit?
    update?
  end

  def update?
    user.present? && owner?
  end

  def destroy?
    user.present? && owner?
  end

  def ping_current?
    show?
  end

  def ping_change?
    show?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
