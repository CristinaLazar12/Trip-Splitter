class ExpensesController < ApplicationController

  def index
    @trip = Trip.find(params[:trip_id])
    @expenses = @trip.expenses #toate expenses
  end

  def new
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new
  end

  def create
    @trip = Trip.find(params[:trip_id])
    @expense = Expense.new(expense_params)
    @expense.trip_id = @trip.id #corelam expenseul cu tripul

    if @expense.save
      redirect_to trip_expense_path(@trip, @expense)
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def show
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id]) #show la un singur expense, nu la toate
  end

  def edit
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id]) #show la un singur expense, nu la toate
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id]) 

    if @expense.update(expense_params)
      redirect_to trip_expense_path(@trip, @expense), notice: "Expense updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @trip = Trip.find(params[:trip_id])
    @expense = @trip.expenses.find(params[:id]) #show la un singur expense, nu la toate
    @expense.destroy

    redirect_to trip_path, notice: "Expense deleted successfully."
  end

  private

  def expense_params
    params.require(:expense).permit(:title, :amount, :currency, :date, :split_type, :trip_id, :payer_id)
  end
end