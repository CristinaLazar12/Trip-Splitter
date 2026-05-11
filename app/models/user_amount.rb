class UserAmount
  def initialize(user, trip)
    @user = user
    @trip = trip
  end

  def amount_to_receive(expense)
    unless @user == expense.payer
        0
    else
      expense
        .expenses_users
        .where.not(user_id: @user.id) # toate expense_users inafara de cele ale platitorului; deci inafara de partea lui
        .sum(:amount)
    end
  end

  def amount_to_pay(expense)
    if @user == expense.payer
      0
    else
      expense
        .expenses_users
        .where(user_id: @user.id)
        .sum(:amount)
    end
  end
end
