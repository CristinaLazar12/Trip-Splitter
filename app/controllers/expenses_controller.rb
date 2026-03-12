class ExpensesController < ApplicationController

  def index
    @trip = Trip.find(params[:trip_id])
    @expenses = @trip.expenses
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new(expense_params)

    if @expense.save
      redirect_to trip_expenses_url(@trip)
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    @trip = Trip.find(params[:trip_id])
    @expenses = @trip.expenses
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :amount, :currency, :date, :split_type, :trip_id, :payer_id)
  end
end