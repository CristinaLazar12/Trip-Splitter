class ExpensesController < ApplicationController
  def new
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to @trip
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :amount, :currency, :date)
  end
end