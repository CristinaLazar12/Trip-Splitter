class ExpensePolicy < ApplicationPolicy
    attr_reader :user, :expense

    def initialize(user, expense)
      @user = user
      @expense = expense
    end

    def edit?
      can_manage_expense?
    end

    def update?
      can_manage_expense?
    end

    def destroy?
      can_manage_expense?
    end

    def create?
      trip_participant?
    end

    private

    def trip_participant?
      expense.trip.participants.include?(user)
    end

    def can_manage_expense?
      trip_creator? ||
      expense_creator? ||
      expense_payer?
    end

    def trip_creator?
      expense.trip.creator == user
    end

    def expense_creator?
      expense.creator == user
    end

    def expense_payer?
      expense.payer == user
    end
end
