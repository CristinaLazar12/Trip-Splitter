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

  def total_to_receive
    @trip.expenses.sum{|expense| amount_to_receive(expense) }
    #luam toate expenses din trip; pentru fecare expense se calculeaza amount_to_receive pe acel expense si apoi se face sum
  end

  def total_to_pay
    @trip.expenses.sum{|expense| amount_to_pay(expense) }
    #luam toate expenses din trip; pentru fecare expense se calculeaza amount_to_ pe acel expense si apoi se face sum
  end

  def final_balance
    #cat ramane la final dupa ce se scade din cat trebuie sa primeasca, cat trebuie sa dea (amount-to_receive - amount_to_pay)
    return total_to_receive - total_to_pay
  end
end
